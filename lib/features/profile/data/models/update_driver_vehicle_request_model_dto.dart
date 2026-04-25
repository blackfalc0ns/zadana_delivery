class UpdateDriverVehicleRequestModelDto {
  const UpdateDriverVehicleRequestModelDto({
    required this.vehicleType,
    required this.nationalId,
    required this.licenseNumber,
    required this.primaryZoneId,
  });

  final String vehicleType;
  final String nationalId;
  final String licenseNumber;
  final String primaryZoneId;

  Map<String, dynamic> toJson() => {
    'vehicleType': vehicleType,
    'nationalId': nationalId,
    'licenseNumber': licenseNumber,
    'primaryZoneId': primaryZoneId,
  };
}
