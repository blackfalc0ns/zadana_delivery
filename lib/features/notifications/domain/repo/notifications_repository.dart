import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/notifications/domain/entities/driver_notifications_page_entity.dart';
import 'package:zadana_delivery/features/notifications/domain/entities/notification_action_response_entity.dart';
import 'package:zadana_delivery/features/notifications/domain/entities/notification_unread_count_entity.dart';

abstract class NotificationsRepository {
  Future<ApiResult<DriverNotificationsPageEntity>> getNotifications({
    int page = 1,
    int perPage = 20,
  });

  Future<ApiResult<NotificationActionResponseEntity>> markAsRead(String id);

  Future<ApiResult<NotificationActionResponseEntity>> markAllAsRead();

  Future<ApiResult<NotificationUnreadCountEntity>> getUnreadCount();

  Future<ApiResult<NotificationActionResponseEntity>> deleteNotification(
    String id,
  );

  Future<ApiResult<NotificationActionResponseEntity>> deleteAllNotifications();

  Future<ApiResult<Map<String, dynamic>>> getPreferences();

  Future<ApiResult<Map<String, dynamic>>> updatePreferences(
    Map<String, dynamic> body,
  );
}
