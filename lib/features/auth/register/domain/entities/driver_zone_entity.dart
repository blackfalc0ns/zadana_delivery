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

  DriverRegionCityEntity copyWith({
    String? id,
    String? regionCode,
    String? regionName,
    String? cityName,
    double? centerLat,
    double? centerLng,
    double? radiusKm,
    bool? isActive,
  }) {
    return DriverRegionCityEntity(
      id: id ?? this.id,
      regionCode: regionCode ?? this.regionCode,
      regionName: regionName ?? this.regionName,
      cityName: cityName ?? this.cityName,
      centerLat: centerLat ?? this.centerLat,
      centerLng: centerLng ?? this.centerLng,
      radiusKm: radiusKm ?? this.radiusKm,
      isActive: isActive ?? this.isActive,
    );
  }
}
