class UpdateDriverVehicleRequestModelDto {
  const UpdateDriverVehicleRequestModelDto({
    required this.vehicleType,
    required this.nationalId,
    required this.licenseNumber,
    required this.nationalIdExpiryDate,
    required this.driverLicenseExpiryDate,
    required this.vehicleLicenseNumber,
    required this.vehicleLicenseExpiryDate,
    required this.region,
    this.city,
  });

  final String vehicleType;
  final String nationalId;
  final String licenseNumber;
  final String nationalIdExpiryDate;
  final String driverLicenseExpiryDate;
  final String vehicleLicenseNumber;
  final String vehicleLicenseExpiryDate;
  final String region;
  final String? city;

  Map<String, dynamic> toJson() => {
    'vehicleType': vehicleType,
    'nationalId': nationalId,
    'licenseNumber': licenseNumber,
    'nationalIdExpiryDate': nationalIdExpiryDate,
    'driverLicenseExpiryDate': driverLicenseExpiryDate,
    'vehicleLicenseNumber': vehicleLicenseNumber,
    'vehicleLicenseExpiryDate': vehicleLicenseExpiryDate,
    'region': region,
    if (city != null) 'city': city,
  };
}
