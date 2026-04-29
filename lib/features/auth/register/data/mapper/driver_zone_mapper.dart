import '../../domain/entities/driver_zone_entity.dart';
import '../models/driver_zone_model_dto.dart';

extension DriverRegionCityModelDtoMapper on DriverRegionCityModelDto {
  DriverRegionCityEntity toEntity() {
    return DriverRegionCityEntity(
      id: id,
      regionCode: regionCode,
      regionName: regionName,
      cityName: cityName,
      centerLat: centerLat,
      centerLng: centerLng,
      radiusKm: radiusKm,
      isActive: isActive,
    );
  }
}
