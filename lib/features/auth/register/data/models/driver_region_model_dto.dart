class DriverRegionModelDto {
  const DriverRegionModelDto({
    required this.code,
    required this.nameAr,
    required this.nameEn,
    this.latitude = 0,
    this.longitude = 0,
    this.mapZoom = 0,
    this.sortOrder = 0,
    this.isOperational = false,
  });

  factory DriverRegionModelDto.fromJson(Map<String, dynamic> json) {
    return DriverRegionModelDto(
      code: json['code']?.toString() ?? '',
      nameAr: json['nameAr']?.toString() ?? '',
      nameEn: json['nameEn']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      mapZoom: (json['mapZoom'] as num?)?.toInt() ?? 0,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      isOperational: json['isOperational'] == true,
    );
  }

  final String code;
  final String nameAr;
  final String nameEn;
  final double latitude;
  final double longitude;
  final int mapZoom;
  final int sortOrder;
  final bool isOperational;
}
