import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/notifications/domain/entities/driver_notifications_page_entity.dart';
import 'package:zadana_delivery/features/notifications/domain/repo/notifications_repository.dart';

@injectable
class GetDriverNotificationsUseCase {
  const GetDriverNotificationsUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<ApiResult<DriverNotificationsPageEntity>> call({
    int page = 1,
    int perPage = 20,
  }) {
    return _repository.getNotifications(page: page, perPage: perPage);
  }
}
