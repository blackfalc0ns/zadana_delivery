import 'package:zadana_delivery/features/driver_tracking/domain/entities/driver_tracking_state_entity.dart';

abstract class DriverTrackingRemoteDataSource {
  Future<void> initialize();

  Future<void> startTracking(DriverTrackingCommandEntity command);

  Future<void> stopTracking();

  Future<void> syncTrackingStatus(DriverTrackingCommandEntity? command);

  Future<void> pushDriverLocation();

  Future<void> syncAppLifecycleState(bool isForeground);

  Stream<DriverTrackingStateEntity> watchState();
}
