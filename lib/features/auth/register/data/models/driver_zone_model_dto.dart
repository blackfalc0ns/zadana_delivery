class DriverZoneModelDto {
  const DriverZoneModelDto({
    required this.id,
    required this.city,
    required this.name,
    required this.centerLat,
    required this.centerLng,
    required this.radiusKm,
    required this.isActive,
  });

  factory DriverZoneModelDto.fromJson(Map<String, dynamic> json) {
    return DriverZoneModelDto(
      id: json['id']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      centerLat: (json['centerLat'] as num?)?.toDouble() ?? 0,
      centerLng: (json['centerLng'] as num?)?.toDouble() ?? 0,
      radiusKm: (json['radiusKm'] as num?)?.toDouble() ?? 0,
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  final String id;
  final String city;
  final String name;
  final double centerLat;
  final double centerLng;
  final double radiusKm;
  final bool isActive;
}
