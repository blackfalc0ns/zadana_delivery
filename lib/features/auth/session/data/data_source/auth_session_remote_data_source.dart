import '../models/auth_session_user_model_dto.dart';
import '../models/refresh_token_request_model_dto.dart';
import '../models/refresh_token_response_model_dto.dart';
import '../models/update_current_driver_request_model_dto.dart';

abstract class AuthSessionRemoteDataSource {
  Future<AuthSessionUserModelDto> getCurrentDriver();

  Future<AuthSessionUserModelDto> updateCurrentDriver(
    UpdateCurrentDriverRequestModelDto request,
  );

  Future<RefreshTokenResponseModelDto> refreshToken(
    RefreshTokenRequestModelDto request,
  );

  Future<void> logout(String refreshToken);
}
