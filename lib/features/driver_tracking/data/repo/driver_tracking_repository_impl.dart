import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/features/driver_tracking/data/data_source/driver_tracking_remote_data_source.dart';
import 'package:zadana_delivery/features/driver_tracking/domain/entities/driver_tracking_state_entity.dart';
import 'package:zadana_delivery/features/driver_tracking/domain/repo/driver_tracking_repository.dart';

@LazySingleton(as: DriverTrackingRepository)
class DriverTrackingRepositoryImpl implements DriverTrackingRepository {
  const DriverTrackingRepositoryImpl(this._remoteDataSource);

  final DriverTrackingRemoteDataSource _remoteDataSource;

  @override
  Future<void> initialize() => _remoteDataSource.initialize();

  @override
  Future<void> pushDriverLocation() => _remoteDataSource.pushDriverLocation();

  @override
  Future<void> syncAppLifecycleState(bool isForeground) {
    return _remoteDataSource.syncAppLifecycleState(isForeground);
  }

  @override
  Future<void> startTracking(DriverTrackingCommandEntity command) {
    return _remoteDataSource.startTracking(command);
  }

  @override
  Future<void> stopTracking() => _remoteDataSource.stopTracking();

  @override
  Future<void> syncTrackingStatus(DriverTrackingCommandEntity? command) {
    return _remoteDataSource.syncTrackingStatus(command);
  }

  @override
  Stream<DriverTrackingStateEntity> watchState() {
    return _remoteDataSource.watchState();
  }
}
