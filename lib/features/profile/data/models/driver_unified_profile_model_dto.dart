class DriverUnifiedProfileModelDto {
  const DriverUnifiedProfileModelDto({
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

  factory DriverUnifiedProfileModelDto.fromJson(Map<String, dynamic> json) {
    return DriverUnifiedProfileModelDto(
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      vehicleType: json['vehicleType']?.toString() ?? '',
      licenseNumber: json['licenseNumber']?.toString() ?? '',
      nationalId: json['nationalId']?.toString() ?? '',
      personalPhotoUrl: json['personalPhotoUrl']?.toString() ?? '',
      nationalIdImageUrl:
          json['nationalIdImageUrl']?.toString() ??
          json['nationalIdFrontImageUrl']?.toString() ??
          '',
      licenseImageUrl: json['licenseImageUrl']?.toString() ?? '',
      vehicleImageUrl: json['vehicleImageUrl']?.toString() ?? '',
      primaryZoneId: json['primaryZoneId']?.toString() ?? '',
      zoneName: json['zoneName']?.toString() ?? '',
      verificationStatus: json['verificationStatus']?.toString() ?? '',
      accountStatus: json['accountStatus']?.toString() ?? '',
      reviewNote: json['reviewNote']?.toString(),
      suspensionReason: json['suspensionReason']?.toString(),
      isProfileComplete: json['isProfileComplete'] == true,
      completionPercent: _readInt(json['completionPercent']),
      missingRequirements: _readStringList(json['missingRequirements']),
      canSubmitForReview: json['canSubmitForReview'] == true,
    );
  }

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
}
