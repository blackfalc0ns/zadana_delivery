class DriverRegionCityEntity {
  const DriverRegionCityEntity({
    required this.id,
    required this.regionCode,
    required this.regionName,
    required this.cityName,
    required this.centerLat,
    required this.centerLng,
    required this.radiusKm,
    required this.isActive,
  });

  final String id;
  final String regionCode;
  final String regionName;
  final String cityName;
  final double centerLat;
  final double centerLng;
  final double radiusKm;
  final bool isActive;
}
