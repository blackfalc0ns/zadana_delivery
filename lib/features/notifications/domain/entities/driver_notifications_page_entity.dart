import 'package:zadana_delivery/features/notifications/domain/entities/driver_notification_entity.dart';

class DriverNotificationsPageEntity {
  const DriverNotificationsPageEntity({
    required this.items,
    required this.page,
    required this.perPage,
    required this.total,
    required this.unreadCount,
    required this.hasMore,
  });

  final List<DriverNotificationEntity> items;
  final int page;
  final int perPage;
  final int total;
  final int unreadCount;
  final bool hasMore;

  DriverNotificationsPageEntity copyWith({
    List<DriverNotificationEntity>? items,
    int? page,
    int? perPage,
    int? total,
    int? unreadCount,
    bool? hasMore,
  }) {
    return DriverNotificationsPageEntity(
      items: items ?? this.items,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      total: total ?? this.total,
      unreadCount: unreadCount ?? this.unreadCount,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
