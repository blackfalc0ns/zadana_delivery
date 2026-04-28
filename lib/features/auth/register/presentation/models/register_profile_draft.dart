class RegisterProfileDraft {
  const RegisterProfileDraft({
    required this.vehicleType,
    required this.zoneId,
    required this.zoneRegionCode,
    required this.zoneName,
    required this.zoneCity,
    required this.address,
    required this.nationalId,
    required this.licenseNumber,
    required this.images,
  });

  final String vehicleType;
  final String zoneId;
  final String zoneRegionCode;
  final String zoneName;
  final String zoneCity;
  final String address;
  final String nationalId;
  final String licenseNumber;
  final Map<String, String> images;

  RegisterProfileDraft copyWith({
    String? vehicleType,
    String? zoneId,
    String? zoneRegionCode,
    String? zoneName,
    String? zoneCity,
    String? address,
    String? nationalId,
    String? licenseNumber,
    Map<String, String>? images,
  }) {
    return RegisterProfileDraft(
      vehicleType: vehicleType ?? this.vehicleType,
      zoneId: zoneId ?? this.zoneId,
      zoneRegionCode: zoneRegionCode ?? this.zoneRegionCode,
      zoneName: zoneName ?? this.zoneName,
      zoneCity: zoneCity ?? this.zoneCity,
      address: address ?? this.address,
      nationalId: nationalId ?? this.nationalId,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      images: images ?? this.images,
    );
  }

  static const empty = RegisterProfileDraft(
    vehicleType: '',
    zoneId: '',
    zoneRegionCode: '',
    zoneName: '',
    zoneCity: '',
    address: '',
    nationalId: '',
    licenseNumber: '',
    images: <String, String>{},
  );
}
