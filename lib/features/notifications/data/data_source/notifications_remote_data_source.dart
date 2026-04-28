import 'package:zadana_delivery/features/notifications/data/models/driver_notifications_response_model_dto.dart';
import 'package:zadana_delivery/features/notifications/data/models/notification_action_response_model_dto.dart';
import 'package:zadana_delivery/features/notifications/data/models/notification_unread_count_response_model_dto.dart';

abstract class NotificationsRemoteDataSource {
  Future<DriverNotificationsResponseModelDto> getNotifications({
    int page = 1,
    int perPage = 20,
  });

  Future<NotificationActionResponseModelDto> markAsRead(String id);

  Future<NotificationActionResponseModelDto> markAllAsRead();

  Future<NotificationUnreadCountResponseModelDto> getUnreadCount();
}
