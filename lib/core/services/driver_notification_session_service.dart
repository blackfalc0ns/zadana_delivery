import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/features/driver_home/data/data_source/driver_home_remote_data_source.dart';

import 'driver_notification_bootstrap_service.dart';
import 'driver_notification_dedup_service.dart';
import 'driver_notification_device_service.dart';
import 'driver_notification_router_service.dart';
import 'driver_realtime_service.dart';
import 'driver_runtime_services_controller.dart';
import 'token_service.dart';

@lazySingleton
class DriverNotificationSessionService {
  DriverNotificationSessionService(
    this._tokenService,
    this._bootstrapService,
    this._deviceService,
    this._runtimeServicesController,
    this._driverRealtimeService,
    this._driverHomeRemoteDataSource,
    this._routerService,
    this._dedupService,
  );

  final TokenService _tokenService;
  final DriverNotificationBootstrapService _bootstrapService;
  final DriverNotificationDeviceService _deviceService;
  final DriverRuntimeServicesController _runtimeServicesController;
  final DriverRealtimeService _driverRealtimeService;
  final DriverHomeRemoteDataSource _driverHomeRemoteDataSource;
  final DriverNotificationRouterService _routerService;
  final DriverNotificationDedupService _dedupService;

  Future<void> restoreAuthenticatedSessionIfPossible() async {
    final accessToken = await _tokenService.getToken();
    if ((accessToken ?? '').trim().isEmpty) {
      _routerService.lockNavigation();
      return;
    }

    await _runtimeServicesController.initializeDriverRuntimeServices();
    await _bootstrapService.restoreAuthenticatedPushIfPossible();
    await _deviceService.registerCurrentDeviceIfAuthenticated();
    await _driverRealtimeService.ensureConnected();
    // Sync per-category notification sound preferences locally.
    try {
      await _deviceService.getDevicePreferences();
    } catch (_) {}
  }

  Future<void> handleSuccessfulAuthentication(String userId) async {
    await _tokenService.saveCurrentUserId(userId);
    debugPrint(
      '╔══════════════════════════════════════════════════════════════╗\n'
      '║  [PUSH DEBUG] handleSuccessfulAuthentication                ║\n'
      '║  userId (external_user_id for OneSignal): $userId\n'
      '╚══════════════════════════════════════════════════════════════╝',
    );
    try {
      await _runtimeServicesController.initializeDriverRuntimeServices();
    } catch (_) {
      // Runtime services (background tracking, SignalR) may fail on iOS during
      // first login due to BGTaskScheduler not being fully ready. This is
      // non-critical — the home screen will retry when it bootstraps.
    }
    try {
      await _bootstrapService.prepareAuthenticatedPush(userId);
    } catch (e) {
      debugPrint('[PUSH DEBUG] prepareAuthenticatedPush FAILED: $e');
    }
    try {
      await _deviceService.registerCurrentDeviceIfAuthenticated(force: true);
    } catch (e) {
      debugPrint('[PUSH DEBUG] registerCurrentDevice FAILED: $e');
    }
    try {
      await _driverRealtimeService.ensureConnected();
    } catch (_) {}

    // Log final push state for backend verification
    try {
      final oneSignalExternalId =
          await _bootstrapService.getExternalIdForDebug();
      final oneSignalSubscriptionId =
          await _bootstrapService.getSubscriptionIdForDebug();
      final pushToken = _deviceService.pushToken;
      final deviceId = await _deviceService.getDeviceId();
      debugPrint(
        '╔══════════════════════════════════════════════════════════════╗\n'
        '║  [PUSH DEBUG] Final state after authentication              ║\n'
        '║  userId sent to OneSignal.login(): $userId\n'
        '║  OneSignal externalId: $oneSignalExternalId\n'
        '║  OneSignal subscriptionId: $oneSignalSubscriptionId\n'
        '║  FCM pushToken: ${pushToken.isEmpty ? "MISSING!" : "${pushToken.substring(0, 20)}..."}\n'
        '║  deviceId: $deviceId\n'
        '║  NOTE: Backend must send to external_user_id = $userId\n'
        '╚══════════════════════════════════════════════════════════════╝',
      );
    } catch (e) {
      debugPrint('[PUSH DEBUG] Failed to log final state: $e');
    }
  }

  Future<void> handleAccessTokenRefreshed() async {
    final accessToken = await _tokenService.getToken();
    if ((accessToken ?? '').trim().isEmpty) {
      return;
    }

    await _deviceService.registerCurrentDeviceIfAuthenticated(force: true);
    await _driverRealtimeService.ensureConnected();
  }

  Future<void> handleLogout() async {
    await _deviceService.unregisterCurrentDevice();
    await _bootstrapService.logoutPush();
    await _tokenService.deleteCurrentUserId();
    _routerService.lockNavigation();
    _routerService.clearTransientState();
    _dedupService.clear();
    await _driverRealtimeService.disconnect();
    await _driverHomeRemoteDataSource.disconnectRealtime();
  }
}
