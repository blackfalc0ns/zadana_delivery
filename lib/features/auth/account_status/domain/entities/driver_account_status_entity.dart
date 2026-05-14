class DriverAccountStatusEntity {
  const DriverAccountStatusEntity({
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
    required this.primaryZoneId,
    required this.zoneName,
    required this.message,
    required this.messageAr,
    required this.messageEn,
    required this.policyIsFrozen,
  });

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
  final String? primaryZoneId;
  final String? zoneName;
  final String message;
  final String? messageAr;
  final String? messageEn;
  final bool policyIsFrozen;

  String get primaryBlockedMessage {
    for (final candidate in [
      restrictionMessage,
      suspensionReason,
      reviewNote,
      message,
    ]) {
      final normalized = candidate?.trim() ?? '';
      if (normalized.isNotEmpty) return normalized;
    }
    return '';
  }

  String get normalizedAccountStatus => accountStatus.trim().toLowerCase();
  String get normalizedVerificationStatus =>
      verificationStatus.trim().toLowerCase();
  String get normalizedGateStatus => gateStatus.trim().toLowerCase();
  String get normalizedEnforcementLevel =>
      enforcementLevel.trim().toLowerCase();

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
      policyIsFrozen ||
      normalizedGateStatus == 'locked' ||
      normalizedGateStatus == 'suspended' ||
      normalizedEnforcementLevel == 'suspensioncandidate' ||
      (!isOperational && primaryBlockedMessage.isNotEmpty) ||
      (!canGoAvailable && primaryBlockedMessage.isNotEmpty) ||
      (!canReceiveOffers && primaryBlockedMessage.isNotEmpty);

  bool get isApproved =>
      normalizedAccountStatus == 'active' ||
      normalizedAccountStatus == 'approved' ||
      normalizedVerificationStatus == 'approved' ||
      normalizedVerificationStatus == 'verified';

  bool get hasCompletedProfile => (primaryZoneId ?? '').trim().isNotEmpty;

  bool get shouldGoHome =>
      isApproved &&
      isOperational &&
      canGoAvailable &&
      canReceiveOrders &&
      canReceiveOffers &&
      !isPendingReview &&
      !isBlocked;
}
