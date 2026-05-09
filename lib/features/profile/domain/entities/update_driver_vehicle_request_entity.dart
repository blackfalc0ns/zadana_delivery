class UpdateDriverVehicleRequestEntity {
  const UpdateDriverVehicleRequestEntity({
    required this.vehicleType,
    required this.nationalId,
    required this.licenseNumber,
    required this.nationalIdExpiryDate,
    required this.driverLicenseExpiryDate,
    required this.vehicleLicenseNumber,
    required this.vehicleLicenseExpiryDate,
    required this.region,
    required this.city,
  });

  final String vehicleType;
  final String nationalId;
  final String licenseNumber;
  final String nationalIdExpiryDate;
  final String driverLicenseExpiryDate;
  final String vehicleLicenseNumber;
  final String vehicleLicenseExpiryDate;
  final String region;
  final String city;
}
