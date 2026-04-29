import 'package:zadana_delivery/features/driver_tracking/domain/entities/driver_tracking_state_entity.dart';
import 'package:zadana_delivery/features/driver_tracking/domain/repo/driver_tracking_repository.dart';

class SyncDriverTrackingStatusUseCase {
  const SyncDriverTrackingStatusUseCase(this._repository);

  final DriverTrackingRepository _repository;

  Future<void> call(DriverTrackingCommandEntity? command) {
    return _repository.syncTrackingStatus(command);
  }
}
