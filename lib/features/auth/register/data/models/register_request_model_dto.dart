import 'package:json_annotation/json_annotation.dart';

part 'register_request_model_dto.g.dart';

@JsonSerializable()
class RegisterRequestModelDto {
  const RegisterRequestModelDto({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.vehicleType,
    required this.nationalId,
    required this.licenseNumber,
    required this.nationalIdExpiryDate,
    required this.driverLicenseExpiryDate,
    required this.vehicleLicenseNumber,
    required this.vehicleLicenseExpiryDate,
    required this.address,
    required this.region,
    this.city,
    required this.nationalIdFrontImageUrl,
    required this.nationalIdBackImageUrl,
    required this.licenseImageUrl,
    required this.vehicleImageUrl,
    required this.personalPhotoUrl,
  });

  factory RegisterRequestModelDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestModelDtoFromJson(json);

  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String vehicleType;
  final String nationalId;
  final String licenseNumber;
  final String nationalIdExpiryDate;
  final String driverLicenseExpiryDate;
  final String vehicleLicenseNumber;
  final String vehicleLicenseExpiryDate;
  final String address;
  final String region;
  final String? city;
  final String nationalIdFrontImageUrl;
  final String nationalIdBackImageUrl;
  final String licenseImageUrl;
  final String vehicleImageUrl;
  final String personalPhotoUrl;

  Map<String, dynamic> toJson() => _$RegisterRequestModelDtoToJson(this);
}
