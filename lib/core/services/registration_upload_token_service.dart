import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/network_constants.dart';
import 'package:zadana_delivery/core/services/token_interceptor.dart';

/// Manages the short-lived Registration Upload Token used to authorize
/// document uploads during driver registration (before the driver has a JWT).
///
/// The token is issued by `POST /api/registration-upload-tokens/issue` and is
/// valid for 15 minutes. This service caches it and transparently refreshes
/// when it is about to expire (30-second safety margin).
@lazySingleton
class RegistrationUploadTokenService {
  RegistrationUploadTokenService(Dio dio) : _dio = dio;

  final Dio _dio;

  String? _token;
  String? _headerName;
  DateTime? _expiresAtUtc;

  /// Returns a valid upload token, requesting a new one if needed.
  /// The [deviceId] should be a stable device identifier.
  Future<String> ensureToken(String deviceId) async {
    if (_token != null &&
        _headerName != null &&
        _expiresAtUtc != null &&
        _expiresAtUtc!.isAfter(
          DateTime.now().toUtc().add(const Duration(seconds: 30)),
        )) {
      return _token!;
    }

    return _requestNewToken(deviceId);
  }

  /// The header name to use when attaching the token to upload requests.
  /// Defaults to `X-Registration-Upload-Token` if not yet fetched.
  String get headerName => _headerName ?? 'X-Registration-Upload-Token';

  /// Clears the cached token (e.g. after registration completes).
  void clear() {
    _token = null;
    _headerName = null;
    _expiresAtUtc = null;
  }

  Future<String> _requestNewToken(String deviceId) async {
    debugPrint('[RegUploadToken] Requesting new registration upload token');

    final response = await _dio.post<dynamic>(
      EndPoints.registrationUploadTokenIssue,
      data: {'deviceId': deviceId},
      options: Options(
        headers: {'X-Device-Id': deviceId},
        extra: {TokenInterceptor.skipAuthKey: true},
      ),
    );

    final data = response.data;
    final map = data is Map<String, dynamic>
        ? data
        : data is Map
            ? Map<String, dynamic>.from(data)
            : const <String, dynamic>{};

    _token = (map['token'] as String?)?.trim() ?? '';
    _headerName = (map['headerName'] as String?)?.trim() ??
        'X-Registration-Upload-Token';
    final expiresStr = (map['expiresAtUtc'] as String?)?.trim() ?? '';
    _expiresAtUtc =
        expiresStr.isNotEmpty ? DateTime.parse(expiresStr) : null;

    if (_token!.isEmpty) {
      throw Exception('Failed to obtain registration upload token');
    }

    debugPrint(
      '[RegUploadToken] Token obtained, expires at $_expiresAtUtc',
    );
    return _token!;
  }
}
