class DriverRegionCityModelDto {
  const DriverRegionCityModelDto({
    required this.id,
    required this.regionCode,
    required this.regionName,
    required this.cityName,
    required this.centerLat,
    required this.centerLng,
    required this.radiusKm,
    required this.isActive,
  });

  factory DriverRegionCityModelDto.localized({
    required String id,
    required String regionCode,
    required String regionName,
    required String cityName,
    required double centerLat,
    required double centerLng,
    required double radiusKm,
    bool isActive = true,
  }) {
    return DriverRegionCityModelDto(
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

  factory DriverRegionCityModelDto.fromJson(Map<String, dynamic> json) {
    return DriverRegionCityModelDto(
      id: json['id']?.toString() ?? '',
      regionCode: json['regionCode']?.toString() ?? '',
      regionName: json['regionName']?.toString() ?? json['city']?.toString() ?? '',
      cityName: json['cityName']?.toString() ?? json['name']?.toString() ?? '',
      centerLat: (json['centerLat'] as num?)?.toDouble() ?? 0,
      centerLng: (json['centerLng'] as num?)?.toDouble() ?? 0,
      radiusKm: (json['radiusKm'] as num?)?.toDouble() ?? 0,
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  final String id;
  final String regionCode;
  final String regionName;
  final String cityName;
  final double centerLat;
  final double centerLng;
  final double radiusKm;
  final bool isActive;
}
