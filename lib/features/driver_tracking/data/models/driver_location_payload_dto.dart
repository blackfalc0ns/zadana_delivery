class DriverLocationPayloadDto {
  const DriverLocationPayloadDto({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
  });

  final double latitude;
  final double longitude;
  final double accuracyMeters;

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'accuracyMeters': accuracyMeters,
    };
  }
}
