import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/notifications/data/data_source/notifications_remote_data_source.dart';
import 'package:zadana_delivery/features/notifications/data/mapper/notifications_mapper.dart';
import 'package:zadana_delivery/features/notifications/domain/entities/driver_notifications_page_entity.dart';
import 'package:zadana_delivery/features/notifications/domain/entities/notification_action_response_entity.dart';
import 'package:zadana_delivery/features/notifications/domain/entities/notification_unread_count_entity.dart';
import 'package:zadana_delivery/features/notifications/domain/repo/notifications_repository.dart';

@Injectable(as: NotificationsRepository)
class NotificationsRepositoryImpl implements NotificationsRepository {
  const NotificationsRepositoryImpl(this._remoteDataSource);

  final NotificationsRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<DriverNotificationsPageEntity>> getNotifications({
    int page = 1,
    int perPage = 20,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getNotifications(
        page: page,
        perPage: perPage,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<NotificationActionResponseEntity>> markAsRead(String id) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.markAsRead(id);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<NotificationActionResponseEntity>> markAllAsRead() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.markAllAsRead();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<NotificationUnreadCountEntity>> getUnreadCount() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getUnreadCount();
      return response.toEntity();
    });
  }
}
