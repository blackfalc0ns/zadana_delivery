import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/di/di.dart';

import '../network/network_constants.dart';
import 'driver_notification_session_service.dart';
import 'token_interceptor.dart';
import 'token_service.dart';

@injectable
class AuthRefreshService {
  AuthRefreshService(@Named('refreshDio') Dio dio, TokenService tokenService)
      : _dio = dio,
        _tokenService = tokenService;

  final Dio _dio;
  final TokenService _tokenService;

  /// Mutex: only one refresh request can be in-flight at a time.
  /// Concurrent callers will await the same Future.
  Completer<String?>? _refreshCompleter;

  Future<String?> refreshAccessToken() async {
    // If a refresh is already in progress, wait for it.
    if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
      debugPrint('[AuthRefresh] Waiting for in-flight refresh to complete');
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<String?>();

    try {
      final result = await _doRefresh();
      _refreshCompleter!.complete(result);
      return result;
    } catch (e) {
      _refreshCompleter!.complete(null);
      rethrow;
    } finally {
      // Allow next refresh attempt after this one completes.
      _refreshCompleter = null;
    }
  }

  Future<String?> _doRefresh() async {
    final refreshToken = await _tokenService.getRefreshToken();
    if (refreshToken == null || refreshToken.trim().isEmpty) {
      return null;
    }

    final response = await _dio.post<dynamic>(
      EndPoints.driverRefreshToken,
      data: {'refreshToken': refreshToken.trim()},
      options: Options(extra: {TokenInterceptor.skipAuthKey: true}),
    );

    final data = response.data;
    final map = data is Map<String, dynamic>
        ? data
        : data is Map
            ? Map<String, dynamic>.from(data)
            : const <String, dynamic>{};

    final newAccessToken = map['accessToken']?.toString().trim() ?? '';
    final newRefreshToken = map['refreshToken']?.toString().trim() ?? '';

    if (newAccessToken.isEmpty || newRefreshToken.isEmpty) {
      return null;
    }

    await _tokenService.saveAccessToken(newAccessToken);
    await _tokenService.saveRefreshToken(newRefreshToken);
    unawaited(
      getIt<DriverNotificationSessionService>().handleAccessTokenRefreshed(),
    );

    return newAccessToken;
  }
}
