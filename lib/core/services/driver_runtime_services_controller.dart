import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/services/driver_realtime_service.dart';
import 'package:zadana_delivery/features/driver_tracking/domain/repo/driver_tracking_repository.dart';

@lazySingleton
class DriverRuntimeServicesController {
  DriverRuntimeServicesController(
    this._driverTrackingRepository,
    this._driverRealtimeService,
  );

  final DriverTrackingRepository _driverTrackingRepository;
  final DriverRealtimeService _driverRealtimeService;

  bool _isInitialized = false;
  bool _isInitializing = false;
  Object? _lastError;
  Future<void>? _initializationFuture;

  bool get isInitialized => _isInitialized;
  bool get isInitializing => _isInitializing;
  Object? get lastError => _lastError;

  Future<void> initializeDriverRuntimeServices() {
    if (_isInitialized) {
      return Future.value();
    }

    final pendingInitialization = _initializationFuture;
    if (pendingInitialization != null) {
      return pendingInitialization;
    }

    _isInitializing = true;
    _lastError = null;

    final initialization = _initializeOnce();
    _initializationFuture = initialization;
    return initialization;
  }

  Future<void> _initializeOnce() async {
    try {
      await _driverTrackingRepository.initialize();
      await _driverRealtimeService.initialize();
      _isInitialized = true;
    } catch (error) {
      _lastError = error;
      rethrow;
    } finally {
      _isInitializing = false;
      _initializationFuture = null;
    }
  }
}
