import '../models/driver_zone_model_dto.dart';

abstract class DriverRegionsRemoteDataSource {
  Future<List<DriverRegionCityModelDto>> getRegionCities();
}
