import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/driver_region_entity.dart';
import 'package:zadana_delivery/features/auth/register/domain/repo/driver_zones_repository.dart';

@injectable
class GetRegionsUseCase {
  const GetRegionsUseCase(this._repository);

  final DriverRegionsRepository _repository;

  Future<ApiResult<List<DriverRegionEntity>>> call() {
    return _repository.getRegions();
  }
}
