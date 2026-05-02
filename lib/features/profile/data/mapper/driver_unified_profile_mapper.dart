import 'package:zadana_delivery/core/utils/driver_vehicle_type.dart';
import 'package:zadana_delivery/features/profile/data/models/driver_unified_profile_model_dto.dart';
import 'package:zadana_delivery/features/profile/data/models/update_driver_documents_request_model_dto.dart';
import 'package:zadana_delivery/features/profile/data/models/update_driver_personal_request_model_dto.dart';
import 'package:zadana_delivery/features/profile/data/models/update_driver_vehicle_request_model_dto.dart';
import 'package:zadana_delivery/features/profile/domain/entities/driver_unified_profile_entity.dart';
import 'package:zadana_delivery/features/profile/domain/entities/update_driver_documents_request_entity.dart';
import 'package:zadana_delivery/features/profile/domain/entities/update_driver_personal_request_entity.dart';
import 'package:zadana_delivery/features/profile/domain/entities/update_driver_vehicle_request_entity.dart';

extension DriverUnifiedProfileDtoMapper on DriverUnifiedProfileModelDto {
  DriverUnifiedProfileEntity toEntity() {
    return DriverUnifiedProfileEntity(
      fullName: fullName.trim(),
      email: email.trim(),
      phone: phone.trim(),
      address: address.trim(),
      vehicleType: DriverVehicleType.normalize(vehicleType),
      licenseNumber: licenseNumber.trim(),
      nationalId: nationalId.trim(),
      personalPhotoUrl: personalPhotoUrl.trim(),
      nationalIdImageUrl: nationalIdImageUrl.trim(),
      licenseImageUrl: licenseImageUrl.trim(),
      vehicleImageUrl: vehicleImageUrl.trim(),
      primaryZoneId: primaryZoneId.trim(),
      zoneName: zoneName.trim(),
      verificationStatus: verificationStatus.trim(),
      accountStatus: accountStatus.trim(),
      reviewNote: reviewNote?.trim().isEmpty == true
          ? null
          : reviewNote?.trim(),
      suspensionReason: suspensionReason?.trim().isEmpty == true
          ? null
          : suspensionReason?.trim(),
      isProfileComplete: isProfileComplete,
      completionPercent: completionPercent,
      missingRequirements: missingRequirements
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList(),
      canSubmitForReview: canSubmitForReview,
    );
  }
}

extension UpdateDriverPersonalRequestMapper
    on UpdateDriverPersonalRequestEntity {
  UpdateDriverPersonalRequestModelDto toDto() {
    return UpdateDriverPersonalRequestModelDto(
      fullName: fullName.trim(),
      email: email.trim(),
      phone: phone.trim(),
      address: address.trim(),
    );
  }
}

extension UpdateDriverVehicleRequestMapper on UpdateDriverVehicleRequestEntity {
  UpdateDriverVehicleRequestModelDto toDto() {
    return UpdateDriverVehicleRequestModelDto(
      vehicleType: DriverVehicleType.normalize(vehicleType),
      nationalId: nationalId.trim(),
      licenseNumber: licenseNumber.trim(),
      primaryZoneId: primaryZoneId.trim(),
    );
  }
}

extension UpdateDriverDocumentsRequestMapper
    on UpdateDriverDocumentsRequestEntity {
  UpdateDriverDocumentsRequestModelDto toDto() {
    return UpdateDriverDocumentsRequestModelDto(
      personalPhotoUrl: personalPhotoUrl.trim(),
      nationalIdImageUrl: nationalIdImageUrl.trim(),
      licenseImageUrl: licenseImageUrl.trim(),
      vehicleImageUrl: vehicleImageUrl.trim(),
    );
  }
}
