import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/driver_unified_profile_entity.dart';
import '../repo/driver_profile_repository.dart';

@injectable
class GetDriverUnifiedProfileUseCase {
  const GetDriverUnifiedProfileUseCase(this._repository);

  final DriverProfileRepository _repository;

  Future<ApiResult<DriverUnifiedProfileEntity>> call() {
    return _repository.getProfile();
  }
}
