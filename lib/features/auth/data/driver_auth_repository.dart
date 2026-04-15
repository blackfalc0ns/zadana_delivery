import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:zadana_delivery/core/l10n/translations/app_localizations.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/network/api_services.dart';
import 'package:zadana_delivery/core/services/token_service.dart';
import 'package:zadana_delivery/features/auth/data/driver_profile_service.dart';

class DriverAuthUser {
  factory DriverAuthUser.fromJson(Map<String, dynamic> json) {
    return DriverAuthUser(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      role: json['role']?.toString() ?? 'driver',
    );
  }

  const DriverAuthUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
}

class DriverAuthResult {
  const DriverAuthResult({
    required this.message,
    this.user,
    this.isVerified = true,
  });

  final String message;
  final DriverAuthUser? user;
  final bool isVerified;
}

class DriverAuthRepository {
  DriverAuthRepository({
    ApiServices? apiServices,
    TokenService? tokenService,
    DriverProfileService? profileService,
  }) : _apiServices = apiServices ?? GetIt.instance<ApiServices>(),
       _tokenService = tokenService ?? GetIt.instance<TokenService>(),
       _profileService = profileService ?? DriverProfileService();

  final ApiServices _apiServices;
  final TokenService _tokenService;
  final DriverProfileService _profileService;

  Future<ApiResult<DriverAuthResult>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    return safeApiCall(() async {
      final response = await _apiServices.registerDriver({
        'fullName': fullName.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'password': password,
        'vehicleType': null,
        'nationalId': null,
        'licenseNumber': null,
        'address': null,
        'nationalIdImageUrl': null,
        'licenseImageUrl': null,
        'vehicleImageUrl': null,
        'personalPhotoUrl': null,
      });

      final map = _normalizeMap(response);
      final user = _extractUser(map);
      final message = _extractMessage(
        map,
        fallback: _localeText((l) => l.register_success),
      );

      if (user != null) {
        await _profileService.saveIdentity(
          DriverIdentity(
            id: user.id,
            fullName: user.fullName,
            email: user.email,
            phone: user.phone,
            role: user.role,
            lastIdentifier: user.email.isNotEmpty ? user.email : user.phone,
          ),
        );
      }

      return DriverAuthResult(
        message: message,
        user: user,
        isVerified: _extractBool(map, 'isVerified', defaultValue: true),
      );
    });
  }

  Future<ApiResult<DriverAuthResult>> login({
    required String identifier,
    required String password,
  }) async {
    return safeApiCall(() async {
      final response = await _apiServices.loginDriver({
        'identifier': identifier.trim(),
        'password': password,
      });

      final map = _normalizeMap(response);
      final accessToken = _extractToken(map, 'accessToken');
      final refreshToken = _extractToken(map, 'refreshToken');

      if (accessToken.isEmpty || refreshToken.isEmpty) {
        throw Exception(_localeText((l) => l.auth_session_parse_error));
      }

      await _tokenService.saveAccessToken(accessToken);
      await _tokenService.saveRefreshToken(refreshToken);

      var user = _extractUser(map);
      user ??= await _loadCurrentDriver();

      if (user != null) {
        await _profileService.saveIdentity(
          DriverIdentity(
            id: user.id,
            fullName: user.fullName,
            email: user.email,
            phone: user.phone,
            role: user.role,
            lastIdentifier: identifier.trim(),
          ),
        );
      } else {
        await _profileService.saveIdentity(
          _profileService.identity.copyWith(lastIdentifier: identifier.trim()),
        );
      }

      return DriverAuthResult(
        message: _extractMessage(
          map,
          fallback: _localeText((l) => l.login_success),
        ),
        user: user,
      );
    });
  }

  Future<ApiResult<String>> sendResetCode({required String identifier}) async {
    return safeApiCall(() async {
      final response = await _apiServices.forgotDriverPassword({
        'identifier': identifier.trim(),
      });

      return _extractMessage(
        response,
        fallback: _localeText((l) => l.msg_verification_code_sent),
      );
    });
  }

  Future<ApiResult<String>> resetPassword({
    required String identifier,
    required String otpCode,
    required String newPassword,
  }) async {
    return safeApiCall(() async {
      final response = await _apiServices.resetDriverPassword({
        'identifier': identifier.trim(),
        'otpCode': otpCode.trim(),
        'newPassword': newPassword,
      });

      return _extractMessage(
        response,
        fallback: _localeText((l) => l.msg_password_reset_success),
      );
    });
  }

  Future<void> logout() async {
    final refreshToken = await _tokenService.getRefreshToken();

    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _apiServices.logoutDriver({'refreshToken': refreshToken});
      }
    } on DioException {
      // Best effort logout. Local cleanup still happens below.
    } catch (_) {
      // Ignore non-critical logout parsing failures.
    }

    await _tokenService.deleteToken();
    await _tokenService.deleteRefreshToken();
    await _profileService.clearSession();
  }

  Future<DriverAuthUser?> _loadCurrentDriver() async {
    try {
      final response = await _apiServices.getDriverProfile();
      final map = _normalizeMap(response);
      return _extractUser(map);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> _normalizeMap(dynamic response) {
    if (response is Map<String, dynamic>) {
      return response;
    }

    if (response is Map) {
      return Map<String, dynamic>.from(response);
    }

    return {'message': response?.toString() ?? ''};
  }

  DriverAuthUser? _extractUser(dynamic response) {
    final map = _normalizeMap(response);
    final candidate = map['user'] ?? map['data'] ?? map['driver'] ?? map;

    if (candidate is Map<String, dynamic>) {
      if ((candidate['id'] ?? '').toString().isEmpty &&
          (candidate['fullName'] ?? '').toString().isEmpty &&
          (candidate['email'] ?? '').toString().isEmpty &&
          (candidate['phone'] ?? '').toString().isEmpty) {
        return null;
      }

      return DriverAuthUser.fromJson(candidate);
    }

    if (candidate is Map) {
      return DriverAuthUser.fromJson(Map<String, dynamic>.from(candidate));
    }

    return null;
  }

  String _extractToken(Map<String, dynamic> response, String key) {
    final nestedTokens = response['tokens'];

    if (nestedTokens is Map<String, dynamic>) {
      return nestedTokens[key]?.toString() ?? '';
    }

    if (nestedTokens is Map) {
      return nestedTokens[key]?.toString() ?? '';
    }

    return response[key]?.toString() ?? '';
  }

  String _extractMessage(dynamic response, {required String fallback}) {
    final map = _normalizeMap(response);

    for (final key in ['message', 'detail', 'title', 'status']) {
      final value = map[key]?.toString();
      if (value != null && value.trim().isNotEmpty) {
        return value;
      }
    }

    return fallback;
  }

  bool _extractBool(
    Map<String, dynamic> response,
    String key, {
    required bool defaultValue,
  }) {
    final value = response[key];
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return defaultValue;
  }

  String _localeText(String Function(AppLocalizations locale) selector) {
    final locale = lookupAppLocalizations(PlatformDispatcher.instance.locale);
    return selector(locale);
  }
}
