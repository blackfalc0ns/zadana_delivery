import '../models/driver_zone_model_dto.dart';

abstract class DriverZonesRemoteDataSource {
  Future<List<DriverZoneModelDto>> getZones();
}
