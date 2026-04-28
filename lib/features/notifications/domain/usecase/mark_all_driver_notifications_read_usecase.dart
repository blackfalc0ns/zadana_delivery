import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/notifications/domain/entities/notification_action_response_entity.dart';
import 'package:zadana_delivery/features/notifications/domain/repo/notifications_repository.dart';

@injectable
class MarkAllDriverNotificationsReadUseCase {
  const MarkAllDriverNotificationsReadUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<ApiResult<NotificationActionResponseEntity>> call() {
    return _repository.markAllAsRead();
  }
}
