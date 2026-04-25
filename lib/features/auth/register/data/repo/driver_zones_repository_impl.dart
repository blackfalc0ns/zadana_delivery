import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../../domain/entities/driver_zone_entity.dart';
import '../../domain/repo/driver_zones_repository.dart';
import '../data_source/driver_zones_remote_data_source.dart';
import '../mapper/driver_zone_mapper.dart';

@Injectable(as: DriverZonesRepository)
class DriverZonesRepositoryImpl implements DriverZonesRepository {
  const DriverZonesRepositoryImpl(this._remoteDataSource);

  final DriverZonesRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<List<DriverZoneEntity>>> getZones() {
    return safeApiCall(() async {
      final zones = await _remoteDataSource.getZones();
      return zones
          .map((zone) => zone.toEntity())
          .where((zone) => zone.isActive)
          .toList(growable: false);
    });
  }
}
