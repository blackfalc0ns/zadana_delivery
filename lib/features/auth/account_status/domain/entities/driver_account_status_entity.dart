class DriverAccountStatusEntity {
  const DriverAccountStatusEntity({
    required this.driverId,
    required this.gateStatus,
    required this.isOperational,
    required this.canReceiveOrders,
    required this.canGoAvailable,
    required this.isAvailable,
    required this.verificationStatus,
    required this.accountStatus,
    required this.reviewedAtUtc,
    required this.reviewNote,
    required this.suspensionReason,
    required this.restrictionMessage,
    required this.primaryZoneId,
    required this.zoneName,
    required this.message,
  });

  final String driverId;
  final String gateStatus;
  final bool isOperational;
  final bool canReceiveOrders;
  final bool canGoAvailable;
  final bool isAvailable;
  final String verificationStatus;
  final String accountStatus;
  final String? reviewedAtUtc;
  final String? reviewNote;
  final String? suspensionReason;
  final String? restrictionMessage;
  final String? primaryZoneId;
  final String? zoneName;
  final String message;

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

  bool get isApproved =>
      normalizedAccountStatus == 'active' ||
      normalizedAccountStatus == 'approved' ||
      normalizedVerificationStatus == 'approved' ||
      normalizedVerificationStatus == 'verified';

  bool get hasCompletedProfile => (primaryZoneId ?? '').trim().isNotEmpty;

  bool get shouldGoHome => isApproved && !isPendingReview && !isBlocked;
}
