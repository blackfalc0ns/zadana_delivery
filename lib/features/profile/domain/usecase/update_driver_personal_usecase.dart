import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/driver_unified_profile_entity.dart';
import '../entities/update_driver_personal_request_entity.dart';
import '../repo/driver_profile_repository.dart';

@injectable
class UpdateDriverPersonalUseCase {
  const UpdateDriverPersonalUseCase(this._repository);

  final DriverProfileRepository _repository;

  Future<ApiResult<DriverUnifiedProfileEntity>> call(
    UpdateDriverPersonalRequestEntity request,
  ) {
    return _repository.updatePersonal(request);
  }
}
