import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/auth/logout/domain/repo/logout_repository.dart';

@injectable
class LogoutUseCase {
  const LogoutUseCase(this._repository);

  final LogoutRepository _repository;

  Future<ApiResult<void>> call() {
    return _repository.logout();
  }
}
