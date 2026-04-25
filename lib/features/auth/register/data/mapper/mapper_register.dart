import 'package:zadana_delivery/core/utils/driver_vehicle_type.dart';

import '../../domain/entities/register_request_entity.dart';
import '../../domain/entities/register_response_entity.dart';
import '../../domain/entities/register_user_entity.dart';
import '../models/register_request_model_dto.dart';
import '../models/register_response_model_dto.dart';

extension RegisterRequestEntityMapper on RegisterRequestEntity {
  RegisterRequestModelDto toDto({
    required String nationalIdImageUrl,
    required String licenseImageUrl,
    required String vehicleImageUrl,
    required String personalPhotoUrl,
  }) {
    final normalizedVehicleType = DriverVehicleType.normalize(vehicleType);

    return RegisterRequestModelDto(
      fullName: fullName.trim(),
      email: email.trim(),
      phone: phone.trim(),
      password: password,
      vehicleType: normalizedVehicleType,
      nationalId: nationalId.trim(),
      licenseNumber: licenseNumber.trim(),
      address: address.trim(),
      primaryZoneId: primaryZoneId.trim(),
      nationalIdImageUrl: nationalIdImageUrl,
      licenseImageUrl: licenseImageUrl,
      vehicleImageUrl: vehicleImageUrl,
      personalPhotoUrl: personalPhotoUrl,
    );
  }
}

extension RegisterResponseDtoMapper on RegisterResponseModelDto {
  RegisterResponseEntity toEntity() {
    final dto = user;

    return RegisterResponseEntity(
      message: message?.trim() ?? '',
      isVerified: isVerified,
      user: dto == null
          ? null
          : RegisterUserEntity(
              id: dto.id?.trim() ?? '',
              fullName: dto.fullName?.trim() ?? '',
              email: dto.email?.trim() ?? '',
              phone: dto.phone?.trim() ?? '',
              role: dto.role?.trim() ?? 'driver',
              favoritesCount: dto.favoritesCount ?? 0,
            ),
    );
  }
}
