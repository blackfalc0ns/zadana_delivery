import 'package:zadana_delivery/features/profile/data/models/driver_compliance_document_model_dto.dart';
import 'package:zadana_delivery/features/profile/data/models/driver_rejection_policy_model_dto.dart';

class DriverUnifiedProfileModelDto {
  const DriverUnifiedProfileModelDto({
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

  factory DriverUnifiedProfileModelDto.fromJson(Map<String, dynamic> json) {
    return DriverUnifiedProfileModelDto(
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      vehicleType: json['vehicleType']?.toString() ?? '',
      licenseNumber: json['licenseNumber']?.toString() ?? '',
      nationalId: json['nationalId']?.toString() ?? '',
      nationalIdExpiryDate: json['nationalIdExpiryDate']?.toString() ?? '',
      driverLicenseExpiryDate:
          json['driverLicenseExpiryDate']?.toString() ?? '',
      vehicleLicenseNumber: json['vehicleLicenseNumber']?.toString() ?? '',
      vehicleLicenseExpiryDate:
          json['vehicleLicenseExpiryDate']?.toString() ?? '',
      personalPhotoUrl: json['personalPhotoUrl']?.toString() ?? '',
      nationalIdFrontImageUrl:
          json['nationalIdFrontImageUrl']?.toString() ??
          json['nationalIdImageUrl']?.toString() ??
          '',
      nationalIdBackImageUrl:
          json['nationalIdBackImageUrl']?.toString() ??
          json['nationalIdBackImage']?.toString() ??
          '',
      licenseImageUrl: json['licenseImageUrl']?.toString() ?? '',
      vehicleImageUrl: json['vehicleImageUrl']?.toString() ?? '',
      region:
          json['region']?.toString() ?? json['regionCode']?.toString() ?? '',
      city: json['city']?.toString() ?? json['primaryZoneId']?.toString() ?? '',
      regionNameAr: json['regionNameAr']?.toString() ?? '',
      regionNameEn: json['regionNameEn']?.toString() ?? '',
      cityNameAr:
          json['cityNameAr']?.toString() ?? json['zoneName']?.toString() ?? '',
      cityNameEn:
          json['cityNameEn']?.toString() ?? json['zoneName']?.toString() ?? '',
      documents: _readDocuments(json['documents']),
      verificationStatus: json['verificationStatus']?.toString() ?? '',
      accountStatus: json['accountStatus']?.toString() ?? '',
      reviewNote: json['reviewNote']?.toString(),
      suspensionReason: json['suspensionReason']?.toString(),
      isProfileComplete: json['isProfileComplete'] == true,
      completionPercent: _readInt(json['completionPercent']),
      missingRequirements: _readStringList(json['missingRequirements']),
      canSubmitForReview: json['canSubmitForReview'] == true,
      rejectionPolicy: DriverRejectionPolicyModelDto.fromJson(
        _readMap(json['rejectionPolicy']),
      ),
    );
  }

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
  final List<DriverComplianceDocumentModelDto> documents;
  final String verificationStatus;
  final String accountStatus;
  final String? reviewNote;
  final String? suspensionReason;
  final bool isProfileComplete;
  final int completionPercent;
  final List<String> missingRequirements;
  final bool canSubmitForReview;
  final DriverRejectionPolicyModelDto rejectionPolicy;

  static int _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static List<String> _readStringList(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item?.toString() ?? '')
          .where((item) => item.trim().isNotEmpty)
          .toList();
    }
    return const <String>[];
  }

  static List<DriverComplianceDocumentModelDto> _readDocuments(dynamic value) {
    if (value is! List) {
      return const <DriverComplianceDocumentModelDto>[];
    }

    return value
        .whereType<Map>()
        .map(
          (item) => DriverComplianceDocumentModelDto.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  static Map<String, dynamic> _readMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }
}
