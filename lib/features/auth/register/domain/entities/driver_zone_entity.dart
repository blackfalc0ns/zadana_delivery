class DriverZoneEntity {
  const DriverZoneEntity({
    required this.id,
    required this.regionCode,
    required this.city,
    required this.name,
    required this.centerLat,
    required this.centerLng,
    required this.radiusKm,
    required this.isActive,
  });

  final String id;
  final String regionCode;
  final String city;
  final String name;
  final double centerLat;
  final double centerLng;
  final double radiusKm;
  final bool isActive;
}
