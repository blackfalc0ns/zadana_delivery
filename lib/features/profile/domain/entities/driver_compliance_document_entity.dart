class DriverComplianceDocumentEntity {
  const DriverComplianceDocumentEntity({
    required this.documentType,
    required this.status,
    required this.rejectionReason,
    required this.reviewedAtUtc,
    required this.reviewedByName,
  });

  final String documentType;
  final String status;
  final String? rejectionReason;
  final String? reviewedAtUtc;
  final String? reviewedByName;

  String get normalizedDocumentType => documentType.trim().toLowerCase();
  String get normalizedStatus => status.trim().toLowerCase();

  bool get isValid => normalizedStatus == 'valid';
  bool get isReview => normalizedStatus == 'review';
  bool get isRejected => normalizedStatus == 'rejected';
  bool get isExpiring => normalizedStatus == 'expiring';
}
