class DriverComplianceDocumentModelDto {
  const DriverComplianceDocumentModelDto({
    required this.documentType,
    required this.status,
    required this.rejectionReason,
    required this.reviewedAtUtc,
    required this.reviewedByName,
  });

  factory DriverComplianceDocumentModelDto.fromJson(Map<String, dynamic> json) {
    return DriverComplianceDocumentModelDto(
      documentType: json['documentType']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      rejectionReason: json['rejectionReason']?.toString(),
      reviewedAtUtc: json['reviewedAtUtc']?.toString(),
      reviewedByName: json['reviewedByName']?.toString(),
    );
  }

  final String documentType;
  final String status;
  final String? rejectionReason;
  final String? reviewedAtUtc;
  final String? reviewedByName;
}
