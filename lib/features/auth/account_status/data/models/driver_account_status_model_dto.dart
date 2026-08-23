class DriverAccountStatusModelDto {
  const DriverAccountStatusModelDto({
    required this.driverId,
    required this.gateStatus,
    required this.isOperational,
    required this.canReceiveOrders,
    required this.canReceiveOffers,
    required this.canGoAvailable,
    required this.isAvailable,
    required this.verificationStatus,
    required this.accountStatus,
    required this.enforcementLevel,
    required this.reviewedAtUtc,
    required this.reviewNote,
    required this.reviewNoteAr,
    required this.reviewNoteEn,
    required this.suspensionReason,
    required this.restrictionMessage,
    required this.restrictionMessageAr,
    required this.restrictionMessageEn,
    this.region,
    required this.primaryZoneId,
    required this.zoneName,
    required this.message,
    required this.messageAr,
    required this.messageEn,
    required this.policyIsFrozen,
    required this.supportCta,
  });

  factory DriverAccountStatusModelDto.fromJson(Map<String, dynamic> json) {
    final rejectionPolicy = _readMap(json['rejectionPolicy']);
    return DriverAccountStatusModelDto(
      driverId: json['driverId']?.toString() ?? '',
      gateStatus: json['gateStatus']?.toString() ?? '',
      isOperational: json['isOperational'] == true,
      canReceiveOrders: json['canReceiveOrders'] == true,
      canReceiveOffers: json['canReceiveOffers'] == true,
      canGoAvailable: json['canGoAvailable'] == true,
      isAvailable: json['isAvailable'] == true,
      verificationStatus: json['verificationStatus']?.toString() ?? '',
      accountStatus: json['accountStatus']?.toString() ?? '',
      enforcementLevel: json['enforcementLevel']?.toString() ?? '',
      reviewedAtUtc: json['reviewedAtUtc']?.toString(),
      reviewNote: json['reviewNote']?.toString(),
      reviewNoteAr: json['reviewNoteAr']?.toString(),
      reviewNoteEn: json['reviewNoteEn']?.toString(),
      suspensionReason: json['suspensionReason']?.toString(),
      restrictionMessage:
          json['restrictionMessage']?.toString() ??
          rejectionPolicy['restrictionMessage']?.toString(),
      restrictionMessageAr: json['restrictionMessageAr']?.toString(),
      restrictionMessageEn: json['restrictionMessageEn']?.toString(),
      region: json['region']?.toString() ?? json['regionCode']?.toString(),
      primaryZoneId: json['primaryZoneId']?.toString(),
      zoneName: json['zoneName']?.toString(),
      message: json['message']?.toString() ?? '',
      messageAr: json['messageAr']?.toString(),
      messageEn: json['messageEn']?.toString(),
      policyIsFrozen: rejectionPolicy['isFrozen'] == true,
      supportCta: DriverAccountSupportCtaModelDto.fromJsonOrNull(
        json['supportCta'],
      ),
    );
  }

  final String driverId;
  final String gateStatus;
  final bool isOperational;
  final bool canReceiveOrders;
  final bool canReceiveOffers;
  final bool canGoAvailable;
  final bool isAvailable;
  final String verificationStatus;
  final String accountStatus;
  final String enforcementLevel;
  final String? reviewedAtUtc;
  final String? reviewNote;
  final String? reviewNoteAr;
  final String? reviewNoteEn;
  final String? suspensionReason;
  final String? restrictionMessage;
  final String? restrictionMessageAr;
  final String? restrictionMessageEn;
  final String? region;
  final String? primaryZoneId;
  final String? zoneName;
  final String message;
  final String? messageAr;
  final String? messageEn;
  final bool policyIsFrozen;
  final DriverAccountSupportCtaModelDto? supportCta;

  static Map<String, dynamic> _readMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }
}

class DriverAccountSupportCtaModelDto {
  const DriverAccountSupportCtaModelDto({
    required this.endpoint,
    required this.reasonType,
    required this.labelAr,
    required this.labelEn,
  });

  factory DriverAccountSupportCtaModelDto.fromJsonOrNull(dynamic json) {
    final map = DriverAccountStatusModelDto._readMap(json);
    return DriverAccountSupportCtaModelDto(
      endpoint: map['endpoint']?.toString() ?? '',
      reasonType: map['reasonType']?.toString() ?? '',
      labelAr: map['labelAr']?.toString(),
      labelEn: map['labelEn']?.toString(),
    );
  }

  final String endpoint;
  final String reasonType;
  final String? labelAr;
  final String? labelEn;
}
