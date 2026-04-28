import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_delivery/features/notifications/data/models/driver_notification_item_model_dto.dart';

part 'driver_notifications_response_model_dto.g.dart';

@JsonSerializable()
class DriverNotificationsResponseModelDto {
  const DriverNotificationsResponseModelDto({
    this.items = const <DriverNotificationItemModelDto>[],
    this.page = 1,
    this.perPage = 20,
    this.total = 0,
    this.unreadCount = 0,
    this.hasMore = false,
  });

  factory DriverNotificationsResponseModelDto.fromJson(
    Map<String, dynamic> json,
  ) => _$DriverNotificationsResponseModelDtoFromJson(json);

  @JsonKey(fromJson: _itemsFromJson)
  final List<DriverNotificationItemModelDto> items;
  @JsonKey(fromJson: _intFromJson)
  final int page;
  @JsonKey(fromJson: _intFromJson)
  final int perPage;
  @JsonKey(fromJson: _intFromJson)
  final int total;
  @JsonKey(fromJson: _intFromJson)
  final int unreadCount;
  @JsonKey(fromJson: _boolFromJson)
  final bool hasMore;

  Map<String, dynamic> toJson() =>
      _$DriverNotificationsResponseModelDtoToJson(this);

  static List<DriverNotificationItemModelDto> _itemsFromJson(dynamic value) {
    if (value is List) {
      return value
          .map((item) => DriverNotificationItemModelDto.fromJson(_asMap(item)))
          .toList(growable: false);
    }
    return const <DriverNotificationItemModelDto>[];
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }

  static int _intFromJson(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _boolFromJson(dynamic value) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    if (value is num) return value != 0;
    return false;
  }
}
