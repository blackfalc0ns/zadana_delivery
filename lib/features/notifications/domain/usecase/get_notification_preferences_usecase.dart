import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/notifications/domain/repo/notifications_repository.dart';

@injectable
class GetNotificationPreferencesUseCase {
  const GetNotificationPreferencesUseCase(this._repository);

  final NotificationsRepository _repository;

  Future<ApiResult<Map<String, dynamic>>> call() {
    return _repository.getPreferences();
  }
}
