import 'package:json_annotation/json_annotation.dart';

part 'notification_unread_count_response_model_dto.g.dart';

@JsonSerializable()
class NotificationUnreadCountResponseModelDto {
  const NotificationUnreadCountResponseModelDto({this.count = 0});

  factory NotificationUnreadCountResponseModelDto.fromJson(
    Map<String, dynamic> json,
  ) => _$NotificationUnreadCountResponseModelDtoFromJson(json);

  @JsonKey(fromJson: _intFromJson)
  final int count;

  Map<String, dynamic> toJson() =>
      _$NotificationUnreadCountResponseModelDtoToJson(this);

  static int _intFromJson(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
