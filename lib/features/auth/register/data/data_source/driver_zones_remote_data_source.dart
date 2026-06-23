import '../models/driver_region_model_dto.dart';
import '../models/driver_zone_model_dto.dart';

abstract class DriverRegionsRemoteDataSource {
  Future<List<DriverRegionCityModelDto>> getRegionCities();

  Future<List<DriverRegionModelDto>> getRegions();

  Future<List<DriverRegionCityModelDto>> getCitiesByRegion(String regionCode);
}
