import 'package:json_annotation/json_annotation.dart';

part 'notification_action_response_model_dto.g.dart';

@JsonSerializable()
class NotificationActionResponseModelDto {
  const NotificationActionResponseModelDto({this.message = '', this.count});

  factory NotificationActionResponseModelDto.fromJson(
    Map<String, dynamic> json,
  ) => _$NotificationActionResponseModelDtoFromJson(json);

  final String message;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? count;

  Map<String, dynamic> toJson() =>
      _$NotificationActionResponseModelDtoToJson(this);

  static int? _nullableIntFromJson(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}
