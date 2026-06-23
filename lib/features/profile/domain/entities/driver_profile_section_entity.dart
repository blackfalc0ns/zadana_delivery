enum DriverProfileSectionKey { personal, vehicle, documents }

enum DriverProfileSectionStatus { valid, review, rejected }

class DriverProfileSectionEntity {
  const DriverProfileSectionEntity({
    required this.section,
    required this.status,
    this.rejectionReason,
    this.reviewedAtUtc,
  });

  final DriverProfileSectionKey section;
  final DriverProfileSectionStatus status;
  final String? rejectionReason;
  final DateTime? reviewedAtUtc;

  bool get isValid => status == DriverProfileSectionStatus.valid;
  bool get isUnderReview => status == DriverProfileSectionStatus.review;
  bool get isRejected => status == DriverProfileSectionStatus.rejected;
}
