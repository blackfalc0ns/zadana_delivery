import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/driver_zone_entity.dart';

abstract class DriverRegionsRepository {
  Future<ApiResult<List<DriverRegionCityEntity>>> getRegionCities();
}
