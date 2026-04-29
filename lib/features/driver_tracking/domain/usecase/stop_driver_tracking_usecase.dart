import 'package:zadana_delivery/features/driver_tracking/domain/repo/driver_tracking_repository.dart';

class StopDriverTrackingUseCase {
  const StopDriverTrackingUseCase(this._repository);

  final DriverTrackingRepository _repository;

  Future<void> call() {
    return _repository.stopTracking();
  }
}
