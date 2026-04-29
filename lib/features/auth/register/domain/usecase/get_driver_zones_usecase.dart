import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/driver_zone_entity.dart';
import '../repo/driver_zones_repository.dart';

@injectable
class GetDriverRegionsUseCase {
  const GetDriverRegionsUseCase(this._repository);

  final DriverRegionsRepository _repository;

  Future<ApiResult<List<DriverRegionCityEntity>>> call() {
    return _repository.getRegionCities();
  }
}
