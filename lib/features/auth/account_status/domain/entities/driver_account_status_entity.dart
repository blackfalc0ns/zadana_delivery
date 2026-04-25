class DriverAccountStatusEntity {
  const DriverAccountStatusEntity({
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
}
