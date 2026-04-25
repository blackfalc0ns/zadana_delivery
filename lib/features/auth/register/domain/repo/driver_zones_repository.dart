import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/driver_zone_entity.dart';

abstract class DriverZonesRepository {
  Future<ApiResult<List<DriverZoneEntity>>> getZones();
}
