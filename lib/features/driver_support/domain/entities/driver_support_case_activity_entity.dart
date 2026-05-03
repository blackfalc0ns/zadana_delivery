class DriverSupportCaseActivityEntity {
  const DriverSupportCaseActivityEntity({
    required this.id,
    required this.type,
    this.typeLabelAr,
    this.typeLabelEn,
    this.titleAr,
    this.titleEn,
    required this.message,
    required this.createdAt,
    this.actorName,
    this.actorRoleLabelAr,
    this.actorRoleLabelEn,
  });

  final String id;
  final String type;
  final String? typeLabelAr;
  final String? typeLabelEn;
  final String? titleAr;
  final String? titleEn;
  final String message;
  final DateTime? createdAt;
  final String? actorName;
  final String? actorRoleLabelAr;
  final String? actorRoleLabelEn;
}
