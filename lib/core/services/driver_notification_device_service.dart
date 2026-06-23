import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:zadana_delivery/core/network/network_constants.dart';
import 'package:zadana_delivery/core/services/language_service.dart';
import 'package:zadana_delivery/core/services/notification_sound_preferences_service.dart';
import 'package:zadana_delivery/core/services/token_service.dart';
import 'package:zadana_delivery/core/utils/constants.dart';

@lazySingleton
class DriverNotificationDeviceService {
  DriverNotificationDeviceService(
    this._dio,
    this._sharedPreferences,
    this._tokenService,
    this._languageService,
    this._soundPreferencesService,
  );

  final Dio _dio;
  final SharedPreferences _sharedPreferences;
  final TokenService _tokenService;
  final LanguageService _languageService;
  final NotificationSoundPreferencesService _soundPreferencesService;

  final Uuid _uuid = const Uuid();

  String? _lastRegistrationSignature;
  String? _inFlightRegistrationSignature;
  Future<void>? _registrationFuture;

  Future<bool> isPushEnabled() async {
    return _sharedPreferences.getBool(AppConstants.notificationsEnabled) ??
        true;
  }

  Future<void> cachePushToken(
    String? pushToken, {
    String? subscriptionId,
  }) async {
    final normalizedPushToken = pushToken?.trim() ?? '';
    var didChange = false;
    if (normalizedPushToken.isNotEmpty) {
      final previousPushToken = _pushToken;
      if (previousPushToken != normalizedPushToken) {
        await _sharedPreferences.setString(
          AppConstants.notificationPushToken,
          normalizedPushToken,
        );
        didChange = true;
      }
    }

    final normalizedSubscriptionId = subscriptionId?.trim() ?? '';
    if (normalizedSubscriptionId.isNotEmpty) {
      final previousSubscriptionId = _pushSubscriptionId;
      if (previousSubscriptionId != normalizedSubscriptionId) {
        await _sharedPreferences.setString(
          AppConstants.notificationPushSubscriptionId,
          normalizedSubscriptionId,
        );
        didChange = true;
      }
    }

    if (!didChange) {
      return;
    }

    await registerCurrentDeviceIfAuthenticated(force: true);
  }

  Future<void> setPushEnabled(bool enabled) async {
    await _sharedPreferences.setBool(
      AppConstants.notificationsEnabled,
      enabled,
    );
    await _syncPushPreferencesIfAuthenticated(enabled);
  }

  Future<void> registerCurrentDeviceIfAuthenticated({
    bool force = false,
  }) async {
    final accessToken = await _tokenService.getToken();
    final pushToken = _pushToken;
    final subscriptionId = _pushSubscriptionId;
    if ((accessToken ?? '').trim().isEmpty || pushToken.isEmpty) {
      debugPrint(
        '[DriverNotificationDevice] Registration skipped: '
        'hasAccessToken=${(accessToken ?? '').trim().isNotEmpty} '
        'hasPushToken=${pushToken.isNotEmpty} '
        'hasSubscriptionId=${subscriptionId.isNotEmpty}',
      );
      return;
    }

    if (subscriptionId.isEmpty) {
      debugPrint(
        '[DriverNotificationDevice] Registration deferred: '
        'pushToken is available but oneSignalSubscriptionId is still empty. '
        'Will register once subscription ID becomes available.',
      );
      return;
    }

    final deviceId = await _getOrCreateDeviceId();
    final locale = _languageService.getLanguageCode();
    final packageInfo = await PackageInfo.fromPlatform();
    final pushEnabled = await isPushEnabled();
    final body = <String, dynamic>{
      'deviceId': deviceId,
      'deviceToken': pushToken,
      'platform': _resolvePlatform(),
      'deviceName': _resolveDeviceName(),
      'appVersion': packageInfo.version,
      'locale': locale,
      'notificationsEnabled': pushEnabled,
      'dispatchPushEnabled': pushEnabled,
      'assignmentPushEnabled': pushEnabled,
      'supportPushEnabled': pushEnabled,
      'walletPushEnabled': pushEnabled,
      'accountPushEnabled': pushEnabled,
      'notificationSound': 'classic',
      if (_pushSubscriptionId.isNotEmpty)
        'oneSignalSubscriptionId': _pushSubscriptionId,
      if (_pushSubscriptionId.isNotEmpty)
        'pushSubscriptionId': _pushSubscriptionId,
    };

    final signature = body.values.map((value) => '$value').join('|');
    if (!force && _lastRegistrationSignature == signature) {
      debugPrint(
        '[DriverNotificationDevice] Registration skipped because payload is unchanged '
        'for deviceId=$deviceId subscriptionId=${_pushSubscriptionId.isEmpty ? "-" : _pushSubscriptionId}.',
      );
      return;
    }

    final inFlightRegistration = _registrationFuture;
    if (inFlightRegistration != null &&
        _inFlightRegistrationSignature == signature) {
      debugPrint(
        '[DriverNotificationDevice] Registration joined existing in-flight request '
        'for deviceId=$deviceId subscriptionId=${_pushSubscriptionId.isEmpty ? "-" : _pushSubscriptionId}.',
      );
      await inFlightRegistration;
      return;
    }

    final registration = _registerDevice(
      body: body,
      deviceId: deviceId,
      locale: locale,
      appVersion: packageInfo.version,
      signature: signature,
    );
    _registrationFuture = registration;
    _inFlightRegistrationSignature = signature;
    try {
      await registration;
    } finally {
      if (identical(_registrationFuture, registration)) {
        _registrationFuture = null;
        _inFlightRegistrationSignature = null;
      }
    }
  }

  Future<void> unregisterCurrentDevice() async {
    final accessToken = await _tokenService.getToken();
    if ((accessToken ?? '').trim().isEmpty) {
      _lastRegistrationSignature = null;
      return;
    }

    final body = <String, dynamic>{
      'deviceId': await _getOrCreateDeviceId(),
      if (_pushToken.isNotEmpty) 'deviceToken': _pushToken,
      if (_pushSubscriptionId.isNotEmpty)
        'oneSignalSubscriptionId': _pushSubscriptionId,
    };

    final succeeded =
        await _performFirstSuccessfulCall(<Future<dynamic> Function()>[
          () => _dio.post<dynamic>(
            '${EndPoints.driverNotificationDevices}/unregister',
            data: body,
          ),
          () => _dio.delete<dynamic>(
            EndPoints.driverNotificationDevices,
            data: body,
          ),
          () => _dio.post<dynamic>(
            '${EndPoints.driverNotificationDevices}/delete',
            data: body,
          ),
        ]);

    if (succeeded) {
      _lastRegistrationSignature = null;
    }
  }

  /// Updates device notification preferences on the server.
  /// Returns the response body on success, or `null` on failure.
  Future<Map<String, dynamic>?> updateDevicePreferences(
    Map<String, dynamic> preferences,
  ) async {
    final accessToken = await _tokenService.getToken();
    if ((accessToken ?? '').trim().isEmpty) {
      return null;
    }

    final deviceId = await _getOrCreateDeviceId();
    final body = <String, dynamic>{
      'deviceId': deviceId,
      if (_pushToken.isNotEmpty) 'deviceToken': _pushToken,
      ...preferences,
    };

    try {
      final response = await _dio.put<dynamic>(
        '${EndPoints.driverNotificationDevices}/preferences',
        data: body,
      );
      _lastRegistrationSignature = null;
      Map<String, dynamic> result = body;
      if (response.data is Map) {
        result = Map<String, dynamic>.from(response.data as Map);
      }
      // Sync per-category notification sounds locally.
      final notificationSounds = result['notificationSounds'] ??
          preferences['notificationSounds'];
      if (notificationSounds is Map) {
        await _soundPreferencesService.syncFromServerResponse(
          Map<String, dynamic>.from(notificationSounds),
        );
      }
      return result;
    } on DioException catch (error) {
      debugPrint(
        '[DriverNotificationDevice] updateDevicePreferences failed: '
        '${error.message}',
      );
      rethrow;
    }
  }

  /// Fetches the current device preferences from the server.
  /// Returns the response body on success, or `null` on failure.
  Future<Map<String, dynamic>?> getDevicePreferences() async {
    final accessToken = await _tokenService.getToken();
    if ((accessToken ?? '').trim().isEmpty) {
      return null;
    }

    final deviceId = await _getOrCreateDeviceId();
    final queryParams = <String, dynamic>{
      'deviceId': deviceId,
      if (_pushToken.isNotEmpty) 'deviceToken': _pushToken,
    };

    try {
      final response = await _dio.get<dynamic>(
        '${EndPoints.driverNotificationDevices}/preferences',
        queryParameters: queryParams,
      );
      if (response.data is Map) {
        final result = Map<String, dynamic>.from(response.data as Map);
        // Sync per-category notification sounds locally.
        final notificationSounds = result['notificationSounds'];
        if (notificationSounds is Map) {
          await _soundPreferencesService.syncFromServerResponse(
            Map<String, dynamic>.from(notificationSounds),
          );
        }
        return result;
      }
      return null;
    } on DioException catch (error) {
      debugPrint(
        '[DriverNotificationDevice] getDevicePreferences failed: '
        '${error.message}',
      );
      rethrow;
    }
  }

  /// Returns the device ID for external use (e.g., building preference bodies).
  Future<String> getDeviceId() => _getOrCreateDeviceId();

  /// Returns the current push token for external use.
  String get pushToken => _pushToken;

  Future<void> _syncPushPreferencesIfAuthenticated(bool enabled) async {
    await updateDevicePreferences({
      'notificationsEnabled': enabled,
      'dispatchPushEnabled': enabled,
      'assignmentPushEnabled': enabled,
      'supportPushEnabled': enabled,
      'walletPushEnabled': enabled,
      'accountPushEnabled': enabled,
    });
  }

  Future<bool> _performFirstSuccessfulCall(
    List<Future<dynamic> Function()> candidates,
  ) async {
    DioException? lastError;

    for (final candidate in candidates) {
      try {
        await candidate();
        return true;
      } on DioException catch (error) {
        lastError = error;
      } catch (_) {
        // Ignore malformed fallback attempts and keep going.
      }
    }

    if (lastError != null) {
      debugPrint(
        '[DriverNotificationDevice] Request failed: ${lastError.message}',
      );
    }
    return false;
  }

  Future<void> _registerDevice({
    required Map<String, dynamic> body,
    required String deviceId,
    required String locale,
    required String appVersion,
    required String signature,
  }) async {
    debugPrint(
      '╔══════════════════════════════════════════════════════════════╗\n'
      '║  [PUSH REGISTER] Sending device registration to backend     ║\n'
      '║  endpoint: ${EndPoints.driverNotificationDevices}/register\n'
      '║  deviceId: $deviceId\n'
      '║  platform: ${body['platform']}\n'
      '║  oneSignalSubscriptionId: ${body['oneSignalSubscriptionId'] ?? "MISSING!"}\n'
      '║  deviceToken: ${(_pushToken.length > 20) ? "${_pushToken.substring(0, 20)}..." : _pushToken}\n'
      '║  locale: $locale\n'
      '║  appVersion: $appVersion\n'
      '║  dispatchPushEnabled: ${body['dispatchPushEnabled']}\n'
      '║  assignmentPushEnabled: ${body['assignmentPushEnabled']}\n'
      '╚══════════════════════════════════════════════════════════════╝',
    );

    final succeeded =
        await _performFirstSuccessfulCall(<Future<dynamic> Function()>[
          () => _dio.post<dynamic>(
            '${EndPoints.driverNotificationDevices}/register',
            data: body,
          ),
        ]);

    if (succeeded) {
      _lastRegistrationSignature = signature;
      debugPrint(
        '[PUSH REGISTER] ✅ Device registration SUCCEEDED for '
        'deviceId=$deviceId oneSignalSubscriptionId=${body['oneSignalSubscriptionId'] ?? "-"}.',
      );
    } else {
      debugPrint(
        '[PUSH REGISTER] ❌ Device registration FAILED for '
        'deviceId=$deviceId oneSignalSubscriptionId=${body['oneSignalSubscriptionId'] ?? "-"}.',
      );
    }
  }

  Future<String> _getOrCreateDeviceId() async {
    final existingDeviceId = _sharedPreferences.getString(
      AppConstants.notificationDeviceId,
    );
    final normalizedExistingDeviceId = existingDeviceId?.trim() ?? '';
    if (normalizedExistingDeviceId.isNotEmpty) {
      return normalizedExistingDeviceId;
    }

    final generatedDeviceId = _uuid.v4();
    await _sharedPreferences.setString(
      AppConstants.notificationDeviceId,
      generatedDeviceId,
    );
    return generatedDeviceId;
  }

  String get _pushToken =>
      _sharedPreferences
          .getString(AppConstants.notificationPushToken)
          ?.trim() ??
      '';

  String get _pushSubscriptionId =>
      _sharedPreferences
          .getString(AppConstants.notificationPushSubscriptionId)
          ?.trim() ??
      '';

  String _resolvePlatform() {
    if (kIsWeb) return 'Web';
    if (Platform.isIOS || Platform.isMacOS) return 'Apns';
    return 'Fcm';
  }

  String _resolveDeviceName() {
    if (kIsWeb) return 'Web';
    if (Platform.isIOS) return 'iPhone';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    return 'Device';
  }
}
