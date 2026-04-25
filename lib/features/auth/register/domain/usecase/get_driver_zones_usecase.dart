import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/driver_zone_entity.dart';
import '../repo/driver_zones_repository.dart';

@injectable
class GetDriverZonesUseCase {
  const GetDriverZonesUseCase(this._repository);

  final DriverZonesRepository _repository;

  Future<ApiResult<List<DriverZoneEntity>>> call() {
    return _repository.getZones();
  }
}
