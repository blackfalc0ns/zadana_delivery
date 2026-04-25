import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../repo/auth_session_repository.dart';

@injectable
class LogoutUseCase {
  const LogoutUseCase(this._repository);

  final AuthSessionRepository _repository;

  Future<ApiResult<void>> call() {
    return _repository.logout();
  }
}
