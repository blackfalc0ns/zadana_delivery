import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/auth_session_user_entity.dart';
import '../entities/refresh_token_request_entity.dart';
import '../entities/refresh_token_response_entity.dart';
import '../entities/update_current_driver_request_entity.dart';

abstract class AuthSessionRepository {
  Future<ApiResult<AuthSessionUserEntity>> getCurrentDriver();

  Future<ApiResult<AuthSessionUserEntity>> updateCurrentDriver(
    UpdateCurrentDriverRequestEntity request,
  );

  Future<ApiResult<RefreshTokenResponseEntity>> refreshToken(
    RefreshTokenRequestEntity request,
  );
}
