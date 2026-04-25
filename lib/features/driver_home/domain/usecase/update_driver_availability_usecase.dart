import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/driver_home/domain/repo/driver_home_repository.dart';

@injectable
class UpdateDriverAvailabilityUseCase {
  const UpdateDriverAvailabilityUseCase(this._repository);

  final DriverHomeRepository _repository;

  Future<ApiResult<void>> call({required bool isAvailable}) {
    return _repository.updateAvailability(isAvailable: isAvailable);
  }
}
