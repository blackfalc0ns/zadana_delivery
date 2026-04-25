import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/auth_session_user_entity.dart';
import '../repo/auth_session_repository.dart';

@injectable
class GetCurrentDriverUseCase {
  const GetCurrentDriverUseCase(this._repository);

  final AuthSessionRepository _repository;

  Future<ApiResult<AuthSessionUserEntity>> call() {
    return _repository.getCurrentDriver();
  }
}
