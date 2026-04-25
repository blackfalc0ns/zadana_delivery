import '../../domain/entities/auth_session_user_entity.dart';
import '../../domain/entities/refresh_token_request_entity.dart';
import '../../domain/entities/refresh_token_response_entity.dart';
import '../../domain/entities/update_current_driver_request_entity.dart';
import '../models/auth_session_user_model_dto.dart';
import '../models/refresh_token_request_model_dto.dart';
import '../models/refresh_token_response_model_dto.dart';
import '../models/update_current_driver_request_model_dto.dart';

extension AuthSessionUserDtoMapper on AuthSessionUserModelDto {
  AuthSessionUserEntity toEntity() {
    return AuthSessionUserEntity(
      id: id.trim(),
      fullName: fullName.trim(),
      email: email.trim(),
      phone: phone.trim(),
      role: role.trim(),
      favoritesCount: favoritesCount,
    );
  }
}

extension RefreshTokenRequestEntityMapper on RefreshTokenRequestEntity {
  RefreshTokenRequestModelDto toDto() {
    return RefreshTokenRequestModelDto(refreshToken: refreshToken.trim());
  }
}

extension RefreshTokenResponseDtoMapper on RefreshTokenResponseModelDto {
  RefreshTokenResponseEntity toEntity() {
    return RefreshTokenResponseEntity(
      accessToken: accessToken.trim(),
      refreshToken: refreshToken.trim(),
    );
  }
}

extension UpdateCurrentDriverRequestEntityMapper
    on UpdateCurrentDriverRequestEntity {
  UpdateCurrentDriverRequestModelDto toDto() {
    return UpdateCurrentDriverRequestModelDto(
      fullName: fullName.trim(),
      email: email.trim(),
      phone: phone.trim(),
    );
  }
}
