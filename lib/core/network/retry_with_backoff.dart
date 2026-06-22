import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor that automatically retries requests that fail due to:
/// - 429 (Too Many Requests) - using exponential backoff
/// - 404 (Not Found) - server might be temporarily unavailable
/// - 500-599 (Server Errors) - server-side issues
/// - Connection/timeout errors - network issues
class RetryWithBackoffInterceptor extends Interceptor {
  RetryWithBackoffInterceptor({
    this.maxRetries = 3,
    this.baseDelay = const Duration(seconds: 2),
  });

  final int maxRetries;
  final Duration baseDelay;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!_shouldRetry(err)) {
      handler.next(err);
      return;
    }

    final retryCount =
        (err.requestOptions.extra['_retryCount'] as int?) ?? 0;

    if (retryCount >= maxRetries) {
      debugPrint('[RetryBackoff] Max retries ($maxRetries) reached for '
          '${err.requestOptions.method} ${err.requestOptions.path}');
      handler.next(err);
      return;
    }

    // Check for Retry-After header (for 429 responses)
    final retryAfterHeader = err.response?.headers.value('retry-after');
    Duration delay;
    if (retryAfterHeader != null && err.response?.statusCode == 429) {
      final seconds = int.tryParse(retryAfterHeader);
      delay = seconds != null
          ? Duration(seconds: seconds)
          : _exponentialDelay(retryCount);
    } else {
      delay = _exponentialDelay(retryCount);
    }

    final statusCode = err.response?.statusCode ?? 'network_error';
    debugPrint('[RetryBackoff] Error $statusCode received, retrying in ${delay.inMilliseconds}ms '
        '(attempt ${retryCount + 1}/$maxRetries) '
        '${err.requestOptions.method} ${err.requestOptions.path}');

    await Future<void>.delayed(delay);

    final options = err.requestOptions;
    options.extra['_retryCount'] = retryCount + 1;

    try {
      final response = await Dio(
        BaseOptions(
          baseUrl: options.baseUrl,
          headers: options.headers,
        ),
      ).fetch(options);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool _shouldRetry(DioException err) {
    final statusCode = err.response?.statusCode;
    
    // Retry on 429 (Too Many Requests)
    if (statusCode == 429) return true;
    
    // Retry on 404 (Not Found) - server might be temporarily unavailable
    // This can happen during server restarts or deployments
    if (statusCode == 404) return true;
    
    // Retry on 5xx server errors
    if (statusCode != null && statusCode >= 500 && statusCode < 600) {
      return true;
    }
    
    // Retry on connection/timeout errors
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      return true;
    }

    // Retry on unknown errors (connection reset, socket errors, etc.)
    // Only when there's no response (meaning the server was never reached)
    if (err.type == DioExceptionType.unknown && err.response == null) {
      return true;
    }
    
    return false;
  }

  Duration _exponentialDelay(int retryCount) {
    final jitter = Random().nextInt(1000);
    return Duration(
      milliseconds: baseDelay.inMilliseconds * pow(2, retryCount).toInt() +
          jitter,
    );
  }
}
