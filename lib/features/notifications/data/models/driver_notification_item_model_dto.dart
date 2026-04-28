import 'package:json_annotation/json_annotation.dart';

part 'driver_notification_item_model_dto.g.dart';

@JsonSerializable()
class DriverNotificationItemModelDto {
  const DriverNotificationItemModelDto({
    required this.id,
    this.titleAr = '',
    this.titleEn = '',
    this.bodyAr = '',
    this.bodyEn = '',
    this.type = '',
    this.referenceId = '',
    this.data = '',
    this.dataObject,
    this.isRead = false,
    this.createdAtUtc = '',
  });

  factory DriverNotificationItemModelDto.fromJson(Map<String, dynamic> json) =>
      _$DriverNotificationItemModelDtoFromJson(json);

  final String id;
  final String titleAr;
  final String titleEn;
  final String bodyAr;
  final String bodyEn;
  final String type;
  final String referenceId;
  final String data;
  @JsonKey(fromJson: _dataObjectFromJson, toJson: _dataObjectToJson)
  final Map<String, dynamic>? dataObject;
  final bool isRead;
  final String createdAtUtc;

  Map<String, dynamic> toJson() => _$DriverNotificationItemModelDtoToJson(this);

  static Map<String, dynamic>? _dataObjectFromJson(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static Map<String, dynamic>? _dataObjectToJson(Map<String, dynamic>? value) {
    return value;
  }
}
