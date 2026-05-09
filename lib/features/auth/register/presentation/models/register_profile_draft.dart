class RegisterProfileDraft {
  const RegisterProfileDraft({
    required this.vehicleType,
    required this.cityId,
    required this.regionCode,
    required this.cityName,
    required this.regionName,
    required this.address,
    required this.nationalId,
    required this.nationalIdExpiryDate,
    required this.licenseNumber,
    required this.driverLicenseExpiryDate,
    required this.vehicleLicenseNumber,
    required this.vehicleLicenseExpiryDate,
    required this.images,
  });

  final String vehicleType;
  final String cityId;
  final String regionCode;
  final String cityName;
  final String regionName;
  final String address;
  final String nationalId;
  final String nationalIdExpiryDate;
  final String licenseNumber;
  final String driverLicenseExpiryDate;
  final String vehicleLicenseNumber;
  final String vehicleLicenseExpiryDate;
  final Map<String, String> images;

  RegisterProfileDraft copyWith({
    String? vehicleType,
    String? cityId,
    String? regionCode,
    String? cityName,
    String? regionName,
    String? address,
    String? nationalId,
    String? nationalIdExpiryDate,
    String? licenseNumber,
    String? driverLicenseExpiryDate,
    String? vehicleLicenseNumber,
    String? vehicleLicenseExpiryDate,
    Map<String, String>? images,
  }) {
    return RegisterProfileDraft(
      vehicleType: vehicleType ?? this.vehicleType,
      cityId: cityId ?? this.cityId,
      regionCode: regionCode ?? this.regionCode,
      cityName: cityName ?? this.cityName,
      regionName: regionName ?? this.regionName,
      address: address ?? this.address,
      nationalId: nationalId ?? this.nationalId,
      nationalIdExpiryDate: nationalIdExpiryDate ?? this.nationalIdExpiryDate,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      driverLicenseExpiryDate:
          driverLicenseExpiryDate ?? this.driverLicenseExpiryDate,
      vehicleLicenseNumber: vehicleLicenseNumber ?? this.vehicleLicenseNumber,
      vehicleLicenseExpiryDate:
          vehicleLicenseExpiryDate ?? this.vehicleLicenseExpiryDate,
      images: images ?? this.images,
    );
  }

  static const empty = RegisterProfileDraft(
    vehicleType: '',
    cityId: '',
    regionCode: '',
    cityName: '',
    regionName: '',
    address: '',
    nationalId: '',
    nationalIdExpiryDate: '',
    licenseNumber: '',
    driverLicenseExpiryDate: '',
    vehicleLicenseNumber: '',
    vehicleLicenseExpiryDate: '',
    images: <String, String>{},
  );
}
