class DriverSupportCaseActivityEntity {
  const DriverSupportCaseActivityEntity({
    required this.id,
    required this.type,
    required this.message,
    required this.createdAt,
    this.actorName,
  });

  final String id;
  final String type;
  final String message;
  final DateTime? createdAt;
  final String? actorName;
}
