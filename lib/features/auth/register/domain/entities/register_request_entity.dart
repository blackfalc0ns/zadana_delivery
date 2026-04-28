class RegisterRequestEntity {
  const RegisterRequestEntity({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.vehicleType,
    required this.nationalId,
    required this.licenseNumber,
    required this.address,
    required this.region,
    required this.city,
    required this.nationalIdFrontImagePath,
    required this.nationalIdBackImagePath,
    required this.licenseImagePath,
    required this.vehicleImagePath,
    required this.personalPhotoPath,
  });

  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String vehicleType;
  final String nationalId;
  final String licenseNumber;
  final String address;
  final String region;
  final String city;
  final String nationalIdFrontImagePath;
  final String nationalIdBackImagePath;
  final String licenseImagePath;
  final String vehicleImagePath;
  final String personalPhotoPath;
}
