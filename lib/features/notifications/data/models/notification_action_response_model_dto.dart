class NotificationActionResponseModelDto {
  const NotificationActionResponseModelDto({
    this.messageAr = '',
    this.messageEn = '',
    this.count,
  });

  factory NotificationActionResponseModelDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return NotificationActionResponseModelDto(
      messageAr: json['message_ar']?.toString() ?? '',
      messageEn: json['message_en']?.toString() ?? '',
      count: _nullableIntFromJson(json['count']),
    );
  }

  final String messageAr;
  final String messageEn;
  final int? count;

  static int? _nullableIntFromJson(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}
