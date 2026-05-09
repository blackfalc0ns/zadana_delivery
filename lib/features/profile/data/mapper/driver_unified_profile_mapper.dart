import 'package:zadana_delivery/core/helpers/document_expiry_date_helper.dart';
import 'package:zadana_delivery/core/utils/driver_vehicle_type.dart';
import 'package:zadana_delivery/features/profile/data/models/driver_compliance_document_model_dto.dart';
import 'package:zadana_delivery/features/profile/data/models/driver_unified_profile_model_dto.dart';
import 'package:zadana_delivery/features/profile/data/models/update_driver_documents_request_model_dto.dart';
import 'package:zadana_delivery/features/profile/data/models/update_driver_personal_request_model_dto.dart';
import 'package:zadana_delivery/features/profile/data/models/update_driver_vehicle_request_model_dto.dart';
import 'package:zadana_delivery/features/profile/domain/entities/driver_compliance_document_entity.dart';
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
      nationalIdExpiryDate: nationalIdExpiryDate.trim(),
      driverLicenseExpiryDate: driverLicenseExpiryDate.trim(),
      vehicleLicenseNumber: vehicleLicenseNumber.trim(),
      vehicleLicenseExpiryDate: vehicleLicenseExpiryDate.trim(),
      personalPhotoUrl: personalPhotoUrl.trim(),
      nationalIdFrontImageUrl: nationalIdFrontImageUrl.trim(),
      nationalIdBackImageUrl: nationalIdBackImageUrl.trim(),
      licenseImageUrl: licenseImageUrl.trim(),
      vehicleImageUrl: vehicleImageUrl.trim(),
      region: region.trim(),
      city: city.trim(),
      regionNameAr: regionNameAr.trim(),
      regionNameEn: regionNameEn.trim(),
      cityNameAr: cityNameAr.trim(),
      cityNameEn: cityNameEn.trim(),
      documents: documents.map((item) => item.toEntity()).toList(),
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
      nationalIdExpiryDate: DocumentExpiryDateHelper.toBackendValue(
        nationalIdExpiryDate,
      ),
      driverLicenseExpiryDate: DocumentExpiryDateHelper.toBackendValue(
        driverLicenseExpiryDate,
      ),
      vehicleLicenseNumber: vehicleLicenseNumber.trim(),
      vehicleLicenseExpiryDate: DocumentExpiryDateHelper.toBackendValue(
        vehicleLicenseExpiryDate,
      ),
      region: region.trim(),
      city: city.trim(),
    );
  }
}

extension UpdateDriverDocumentsRequestMapper
    on UpdateDriverDocumentsRequestEntity {
  UpdateDriverDocumentsRequestModelDto toDto() {
    return UpdateDriverDocumentsRequestModelDto(
      personalPhotoUrl: personalPhotoUrl.trim(),
      nationalIdFrontImageUrl: nationalIdFrontImageUrl.trim(),
      nationalIdBackImageUrl: nationalIdBackImageUrl.trim(),
      licenseImageUrl: licenseImageUrl.trim(),
      vehicleImageUrl: vehicleImageUrl.trim(),
    );
  }
}

extension DriverComplianceDocumentModelDtoMapper
    on DriverComplianceDocumentModelDto {
  DriverComplianceDocumentEntity toEntity() {
    return DriverComplianceDocumentEntity(
      documentType: documentType.trim(),
      status: status.trim(),
      rejectionReason: rejectionReason?.trim().isEmpty == true
          ? null
          : rejectionReason?.trim(),
      reviewedAtUtc: reviewedAtUtc?.trim().isEmpty == true
          ? null
          : reviewedAtUtc?.trim(),
      reviewedByName: reviewedByName?.trim().isEmpty == true
          ? null
          : reviewedByName?.trim(),
    );
  }
}
