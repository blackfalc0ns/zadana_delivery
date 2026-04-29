class DriverRegionCityApiModelDto {
  const DriverRegionCityApiModelDto({
    required this.regionCode,
    required this.code,
    required this.nameAr,
    required this.nameEn,
    required this.latitude,
    required this.longitude,
    required this.mapZoom,
    required this.sortOrder,
  });

  factory DriverRegionCityApiModelDto.fromJson(Map<String, dynamic> json) {
    return DriverRegionCityApiModelDto(
      regionCode: json['regionCode']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      nameAr: json['nameAr']?.toString() ?? '',
      nameEn: json['nameEn']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      mapZoom: (json['mapZoom'] as num?)?.toInt() ?? 0,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }

  final String regionCode;
  final String code;
  final String nameAr;
  final String nameEn;
  final double latitude;
  final double longitude;
  final int mapZoom;
  final int sortOrder;
}
