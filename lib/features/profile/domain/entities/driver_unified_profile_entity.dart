import 'package:zadana_delivery/core/utils/driver_vehicle_type.dart';

class DriverUnifiedProfileEntity {
  const DriverUnifiedProfileEntity({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.vehicleType,
    required this.licenseNumber,
    required this.nationalId,
    required this.personalPhotoUrl,
    required this.nationalIdImageUrl,
    required this.licenseImageUrl,
    required this.vehicleImageUrl,
    required this.primaryZoneId,
    required this.zoneName,
    required this.verificationStatus,
    required this.accountStatus,
    required this.reviewNote,
    required this.suspensionReason,
    required this.isProfileComplete,
    required this.completionPercent,
    required this.missingRequirements,
    required this.canSubmitForReview,
  });

  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String vehicleType;
  final String licenseNumber;
  final String nationalId;
  final String personalPhotoUrl;
  final String nationalIdImageUrl;
  final String licenseImageUrl;
  final String vehicleImageUrl;
  final String primaryZoneId;
  final String zoneName;
  final String verificationStatus;
  final String accountStatus;
  final String? reviewNote;
  final String? suspensionReason;
  final bool isProfileComplete;
  final int completionPercent;
  final List<String> missingRequirements;
  final bool canSubmitForReview;

  String get normalizedVehicleType => DriverVehicleType.normalize(vehicleType);
  String get normalizedVerificationStatus =>
      verificationStatus.trim().toLowerCase();
  String get normalizedAccountStatus => accountStatus.trim().toLowerCase();

  bool get isPendingReview =>
      normalizedAccountStatus == 'pending' ||
      normalizedVerificationStatus == 'underreview' ||
      normalizedVerificationStatus == 'needsdocuments';

  bool get isBlocked =>
      normalizedAccountStatus == 'blocked' ||
      normalizedAccountStatus == 'suspended' ||
      normalizedAccountStatus == 'inactive' ||
      normalizedAccountStatus == 'rejected' ||
      normalizedVerificationStatus == 'rejected';
}
