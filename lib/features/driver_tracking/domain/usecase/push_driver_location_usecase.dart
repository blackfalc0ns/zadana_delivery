import 'package:zadana_delivery/features/driver_tracking/domain/repo/driver_tracking_repository.dart';

class PushDriverLocationUseCase {
  const PushDriverLocationUseCase(this._repository);

  final DriverTrackingRepository _repository;

  Future<void> call() {
    return _repository.pushDriverLocation();
  }
}
