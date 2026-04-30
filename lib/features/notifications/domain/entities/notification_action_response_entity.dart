class NotificationActionResponseEntity {
  const NotificationActionResponseEntity({
    required this.messageAr,
    required this.messageEn,
    this.count,
  });

  final String messageAr;
  final String messageEn;
  final int? count;
}
