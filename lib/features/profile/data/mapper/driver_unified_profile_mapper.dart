import 'package:zadana_delivery/core/helpers/document_expiry_date_helper.dart';
import 'package:zadana_delivery/core/utils/driver_vehicle_type.dart';
import 'package:zadana_delivery/features/profile/data/models/driver_compliance_document_model_dto.dart';
import 'package:zadana_delivery/features/profile/data/models/driver_rejection_policy_model_dto.dart';
import 'package:zadana_delivery/features/profile/data/models/driver_unified_profile_model_dto.dart';
import 'package:zadana_delivery/features/profile/data/models/update_driver_documents_request_model_dto.dart';
import 'package:zadana_delivery/features/profile/data/models/update_driver_personal_request_model_dto.dart';
import 'package:zadana_delivery/features/profile/data/models/update_driver_vehicle_request_model_dto.dart';
import 'package:zadana_delivery/features/profile/domain/entities/driver_compliance_document_entity.dart';
import 'package:zadana_delivery/features/profile/domain/entities/driver_profile_section_entity.dart';
import 'package:zadana_delivery/features/profile/domain/entities/driver_rejection_policy_entity.dart';
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
      rejectionPolicy: rejectionPolicy.toEntity(),
      sections: sections
          .map(_parseSectionFromJson)
          .toList(growable: false),
    );
  }

  static DriverProfileSectionEntity _parseSectionFromJson(
    Map<String, dynamic> json,
  ) {
    return DriverProfileSectionEntity(
      section: _parseSectionKey(json['section'] as String?),
      status: _parseSectionStatus(json['status'] as String?),
      rejectionReason: (json['rejectionReason'] as String?)?.trim().isEmpty == true
          ? null
          : (json['rejectionReason'] as String?)?.trim(),
      reviewedAtUtc: json['reviewedAtUtc'] != null
          ? DateTime.tryParse(json['reviewedAtUtc'] as String)
          : null,
    );
  }

  static DriverProfileSectionKey _parseSectionKey(String? raw) {
    switch ((raw ?? '').toLowerCase()) {
      case 'vehicle':
        return DriverProfileSectionKey.vehicle;
      case 'documents':
        return DriverProfileSectionKey.documents;
      default:
        return DriverProfileSectionKey.personal;
    }
  }

  static DriverProfileSectionStatus _parseSectionStatus(String? raw) {
    switch ((raw ?? '').toLowerCase()) {
      case 'review':
        return DriverProfileSectionStatus.review;
      case 'rejected':
        return DriverProfileSectionStatus.rejected;
      default:
        return DriverProfileSectionStatus.valid;
    }
  }
}

extension DriverRejectionPolicyModelDtoMapper on DriverRejectionPolicyModelDto {
  DriverRejectionPolicyEntity toEntity() {
    return DriverRejectionPolicyEntity(
      dailyRejections: dailyRejections,
      dailyLimit: dailyLimit,
      remainingBeforeFreeze: remainingBeforeFreeze,
      weeklyRejections: weeklyRejections,
      weeklyLimit: weeklyLimit,
      remainingBeforeWeeklyFreeze: remainingBeforeWeeklyFreeze,
      isFrozen: isFrozen,
      restrictionMessage: restrictionMessage?.trim().isEmpty == true
          ? null
          : restrictionMessage?.trim(),
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
