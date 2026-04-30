import 'package:zadana_delivery/features/notifications/data/models/driver_notification_item_model_dto.dart';
import 'package:zadana_delivery/features/notifications/data/models/driver_notifications_response_model_dto.dart';
import 'package:zadana_delivery/features/notifications/data/models/notification_action_response_model_dto.dart';
import 'package:zadana_delivery/features/notifications/data/models/notification_unread_count_response_model_dto.dart';
import 'package:zadana_delivery/features/notifications/domain/entities/driver_notification_entity.dart';
import 'package:zadana_delivery/features/notifications/domain/entities/driver_notifications_page_entity.dart';
import 'package:zadana_delivery/features/notifications/domain/entities/notification_action_response_entity.dart';
import 'package:zadana_delivery/features/notifications/domain/entities/notification_unread_count_entity.dart';

extension DriverNotificationItemMapper on DriverNotificationItemModelDto {
  DriverNotificationEntity toEntity() {
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
      isRead: isRead,
      createdAt: DateTime.tryParse(createdAtUtc)?.toLocal() ?? DateTime(0),
    );
  }
}

extension DriverNotificationsResponseMapper
    on DriverNotificationsResponseModelDto {
  DriverNotificationsPageEntity toEntity() {
    return DriverNotificationsPageEntity(
      items: items.map((item) => item.toEntity()).toList(growable: false),
      page: page,
      perPage: perPage,
      total: total,
      unreadCount: unreadCount,
      hasMore: hasMore,
    );
  }
}

extension NotificationActionResponseMapper
    on NotificationActionResponseModelDto {
  NotificationActionResponseEntity toEntity() {
    return NotificationActionResponseEntity(
      messageAr: messageAr,
      messageEn: messageEn,
      count: count,
    );
  }
}

extension NotificationUnreadCountResponseMapper
    on NotificationUnreadCountResponseModelDto {
  NotificationUnreadCountEntity toEntity() {
    return NotificationUnreadCountEntity(count: count);
  }
}
