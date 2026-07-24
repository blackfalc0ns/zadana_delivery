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
    debugPrint('[PUSH DEBUG] handleSuccessfulAuthentication started.');
    try {
      await _runtimeServicesController.initializeDriverRuntimeServices();
    } catch (_) {
      // Runtime services (background tracking, SignalR) may fail on iOS during
      // first login due to BGTaskScheduler not being fully ready. This is
      // non-critical — the home screen will retry when it bootstraps.
    }
    try {
      await _bootstrapService.prepareAuthenticatedPush(userId);
    } catch (_) {
      debugPrint('[PUSH DEBUG] prepareAuthenticatedPush FAILED.');
    }
    try {
      await _deviceService.registerCurrentDeviceIfAuthenticated(force: true);
    } catch (_) {
      debugPrint('[PUSH DEBUG] registerCurrentDevice FAILED.');
    }
    try {
      await _driverRealtimeService.ensureConnected();
    } catch (_) {}
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
    await handleLocalLogout();
  }

  /// Clears local notification and realtime state without contacting the API.
  ///
  /// Account closure revokes the server session immediately, so unregistering
  /// the device afterwards would only produce authentication errors.
  Future<void> handleLocalLogout() async {
    await _bootstrapService.logoutPush();
    await _tokenService.deleteCurrentUserId();
    _routerService.lockNavigation();
    _routerService.clearTransientState();
    _dedupService.clear();
    await _driverRealtimeService.disconnect();
    await _driverHomeRemoteDataSource.disconnectRealtime();
  }
}
