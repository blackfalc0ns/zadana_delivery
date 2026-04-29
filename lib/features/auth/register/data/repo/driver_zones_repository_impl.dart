import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../../domain/entities/driver_zone_entity.dart';
import '../../domain/repo/driver_zones_repository.dart';
import '../data_source/driver_zones_remote_data_source.dart';
import '../mapper/driver_zone_mapper.dart';

@Injectable(as: DriverRegionsRepository)
class DriverRegionsRepositoryImpl implements DriverRegionsRepository {
  const DriverRegionsRepositoryImpl(this._remoteDataSource);

  final DriverRegionsRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<List<DriverRegionCityEntity>>> getRegionCities() {
    return safeApiCall(() async {
      final regionCities = await _remoteDataSource.getRegionCities();
      return regionCities
          .map((item) => item.toEntity())
          .where((item) => item.isActive)
          .toList(growable: false);
    });
  }
}
