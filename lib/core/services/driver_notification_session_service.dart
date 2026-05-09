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
  }

  Future<void> handleSuccessfulAuthentication(String userId) async {
    await _tokenService.saveCurrentUserId(userId);
    await _runtimeServicesController.initializeDriverRuntimeServices();
    await _bootstrapService.prepareAuthenticatedPush(userId);
    await _deviceService.registerCurrentDeviceIfAuthenticated(force: true);
    await _driverRealtimeService.ensureConnected();
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
