import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/refresh_token_request_entity.dart';
import '../entities/refresh_token_response_entity.dart';
import '../repo/auth_session_repository.dart';

@injectable
class RefreshTokenUseCase {
  const RefreshTokenUseCase(this._repository);

  final AuthSessionRepository _repository;

  Future<ApiResult<RefreshTokenResponseEntity>> call(
    RefreshTokenRequestEntity request,
  ) {
    return _repository.refreshToken(request);
  }
}
