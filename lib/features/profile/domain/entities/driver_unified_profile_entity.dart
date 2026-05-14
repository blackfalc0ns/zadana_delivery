import 'package:zadana_delivery/core/utils/driver_vehicle_type.dart';
import 'package:zadana_delivery/features/profile/domain/entities/driver_compliance_document_entity.dart';
import 'package:zadana_delivery/features/profile/domain/entities/driver_rejection_policy_entity.dart';

class DriverUnifiedProfileEntity {
  const DriverUnifiedProfileEntity({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.vehicleType,
    required this.licenseNumber,
    required this.nationalId,
    required this.nationalIdExpiryDate,
    required this.driverLicenseExpiryDate,
    required this.vehicleLicenseNumber,
    required this.vehicleLicenseExpiryDate,
    required this.personalPhotoUrl,
    required this.nationalIdFrontImageUrl,
    required this.nationalIdBackImageUrl,
    required this.licenseImageUrl,
    required this.vehicleImageUrl,
    required this.region,
    required this.city,
    required this.regionNameAr,
    required this.regionNameEn,
    required this.cityNameAr,
    required this.cityNameEn,
    required this.documents,
    required this.verificationStatus,
    required this.accountStatus,
    required this.reviewNote,
    required this.suspensionReason,
    required this.isProfileComplete,
    required this.completionPercent,
    required this.missingRequirements,
    required this.canSubmitForReview,
    required this.rejectionPolicy,
  });

  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String vehicleType;
  final String licenseNumber;
  final String nationalId;
  final String nationalIdExpiryDate;
  final String driverLicenseExpiryDate;
  final String vehicleLicenseNumber;
  final String vehicleLicenseExpiryDate;
  final String personalPhotoUrl;
  final String nationalIdFrontImageUrl;
  final String nationalIdBackImageUrl;
  final String licenseImageUrl;
  final String vehicleImageUrl;
  final String region;
  final String city;
  final String regionNameAr;
  final String regionNameEn;
  final String cityNameAr;
  final String cityNameEn;
  final List<DriverComplianceDocumentEntity> documents;
  final String verificationStatus;
  final String accountStatus;
  final String? reviewNote;
  final String? suspensionReason;
  final bool isProfileComplete;
  final int completionPercent;
  final List<String> missingRequirements;
  final bool canSubmitForReview;
  final DriverRejectionPolicyEntity rejectionPolicy;

  String get normalizedVehicleType => DriverVehicleType.normalize(vehicleType);
  String get normalizedVerificationStatus =>
      verificationStatus.trim().toLowerCase();
  String get normalizedAccountStatus => accountStatus.trim().toLowerCase();
  String get nationalIdImageUrl => nationalIdFrontImageUrl;
  String get primaryZoneId => city;
  String get zoneName => displayCityName;
  String get displayRegionName => regionNameAr.trim().isNotEmpty
      ? regionNameAr.trim()
      : regionNameEn.trim();
  String get displayCityName =>
      cityNameAr.trim().isNotEmpty ? cityNameAr.trim() : cityNameEn.trim();

  bool get isPendingReview =>
      normalizedAccountStatus == 'pending' ||
      normalizedVerificationStatus == 'underreview' ||
      normalizedVerificationStatus == 'needsdocuments';

  bool get isBlocked =>
      normalizedAccountStatus == 'blocked' ||
      normalizedAccountStatus == 'suspended' ||
      normalizedAccountStatus == 'inactive' ||
      normalizedAccountStatus == 'rejected' ||
      normalizedVerificationStatus == 'rejected' ||
      rejectionPolicy.isFrozen;

  DriverComplianceDocumentEntity? documentByType(String documentType) {
    final normalizedType = documentType.trim().toLowerCase();
    for (final document in documents) {
      if (document.normalizedDocumentType == normalizedType) {
        return document;
      }
    }
    return null;
  }
}
