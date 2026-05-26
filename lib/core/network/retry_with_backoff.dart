import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor that automatically retries requests that receive a 429
/// (Too Many Requests) response, using exponential backoff.
class RetryWithBackoffInterceptor extends Interceptor {
  RetryWithBackoffInterceptor({
    this.maxRetries = 3,
    this.baseDelay = const Duration(seconds: 2),
  });

  final int maxRetries;
  final Duration baseDelay;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 429) {
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

    // Check for Retry-After header
    final retryAfterHeader = err.response?.headers.value('retry-after');
    Duration delay;
    if (retryAfterHeader != null) {
      final seconds = int.tryParse(retryAfterHeader);
      delay = seconds != null
          ? Duration(seconds: seconds)
          : _exponentialDelay(retryCount);
    } else {
      delay = _exponentialDelay(retryCount);
    }

    debugPrint('[RetryBackoff] 429 received, retrying in ${delay.inMilliseconds}ms '
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

  Duration _exponentialDelay(int retryCount) {
    final jitter = Random().nextInt(1000);
    return Duration(
      milliseconds: baseDelay.inMilliseconds * pow(2, retryCount).toInt() +
          jitter,
    );
  }
}
