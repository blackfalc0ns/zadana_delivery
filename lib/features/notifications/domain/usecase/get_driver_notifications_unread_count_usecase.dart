import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/notifications/domain/entities/notification_unread_count_entity.dart';
import 'package:zadana_delivery/features/notifications/domain/repo/notifications_repository.dart';

@injectable
class GetDriverNotificationsUnreadCountUseCase {
  const GetDriverNotificationsUnreadCountUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<ApiResult<NotificationUnreadCountEntity>> call() {
    return _repository.getUnreadCount();
  }
}
