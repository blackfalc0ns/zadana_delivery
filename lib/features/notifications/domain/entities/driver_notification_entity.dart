class DriverNotificationEntity {
  const DriverNotificationEntity({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.bodyAr,
    required this.bodyEn,
    required this.type,
    required this.referenceId,
    required this.data,
    required this.dataObject,
    required this.isRead,
    required this.createdAt,
  });

  final String id;
  final String titleAr;
  final String titleEn;
  final String bodyAr;
  final String bodyEn;
  final String type;
  final String referenceId;
  final String data;
  final Map<String, dynamic>? dataObject;
  final bool isRead;
  final DateTime createdAt;

  DriverNotificationEntity copyWith({bool? isRead}) {
    return DriverNotificationEntity(
      id: id,
      titleAr: titleAr,
      titleEn: titleEn,
      bodyAr: bodyAr,
      bodyEn: bodyEn,
      type: type,
      referenceId: referenceId,
      data: data,
      dataObject: dataObject,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}
