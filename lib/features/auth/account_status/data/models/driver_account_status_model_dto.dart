class DriverAccountStatusModelDto {
  const DriverAccountStatusModelDto({
    required this.driverId,
    required this.isOperational,
    required this.canReceiveOrders,
    required this.canGoAvailable,
    required this.isAvailable,
    required this.verificationStatus,
    required this.accountStatus,
    required this.reviewedAtUtc,
    required this.reviewNote,
    required this.suspensionReason,
    required this.primaryZoneId,
    required this.zoneName,
    required this.message,
  });

  factory DriverAccountStatusModelDto.fromJson(Map<String, dynamic> json) {
    return DriverAccountStatusModelDto(
      driverId: json['driverId']?.toString() ?? '',
      isOperational: json['isOperational'] == true,
      canReceiveOrders: json['canReceiveOrders'] == true,
      canGoAvailable: json['canGoAvailable'] == true,
      isAvailable: json['isAvailable'] == true,
      verificationStatus: json['verificationStatus']?.toString() ?? '',
      accountStatus: json['accountStatus']?.toString() ?? '',
      reviewedAtUtc: json['reviewedAtUtc']?.toString(),
      reviewNote: json['reviewNote']?.toString(),
      suspensionReason: json['suspensionReason']?.toString(),
      primaryZoneId: json['primaryZoneId']?.toString(),
      zoneName: json['zoneName']?.toString(),
      message: json['message']?.toString() ?? '',
    );
  }

  final String driverId;
  final bool isOperational;
  final bool canReceiveOrders;
  final bool canGoAvailable;
  final bool isAvailable;
  final String verificationStatus;
  final String accountStatus;
  final String? reviewedAtUtc;
  final String? reviewNote;
  final String? suspensionReason;
  final String? primaryZoneId;
  final String? zoneName;
  final String message;
}
