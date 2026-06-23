import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/driver_zone_entity.dart';
import 'package:zadana_delivery/features/auth/register/domain/repo/driver_zones_repository.dart';

@injectable
class GetRegionCitiesUseCase {
  const GetRegionCitiesUseCase(this._repository);

  final DriverRegionsRepository _repository;

  Future<ApiResult<List<DriverRegionCityEntity>>> call({
    required String regionCode,
    required String regionName,
  }) {
    return _repository.getCitiesByRegion(regionCode, regionName);
  }
}
