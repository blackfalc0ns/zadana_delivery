class UpdateDriverVehicleRequestEntity {
  const UpdateDriverVehicleRequestEntity({
    required this.vehicleType,
    required this.nationalId,
    required this.licenseNumber,
    required this.primaryZoneId,
  });

  final String vehicleType;
  final String nationalId;
  final String licenseNumber;
  final String primaryZoneId;
}
