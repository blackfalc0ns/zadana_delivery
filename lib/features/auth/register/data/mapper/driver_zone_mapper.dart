import '../../domain/entities/driver_zone_entity.dart';
import '../models/driver_zone_model_dto.dart';

extension DriverZoneModelDtoMapper on DriverZoneModelDto {
  DriverZoneEntity toEntity() {
    return DriverZoneEntity(
      id: id,
      regionCode: regionCode,
      city: city,
      name: name,
      centerLat: centerLat,
      centerLng: centerLng,
      radiusKm: radiusKm,
      isActive: isActive,
    );
  }
}
