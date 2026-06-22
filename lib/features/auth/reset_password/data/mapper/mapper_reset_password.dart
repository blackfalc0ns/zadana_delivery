import '../../domain/entities/reset_password_request_entity.dart';
import '../../domain/entities/reset_password_response_entity.dart';
import '../models/reset_password_request_model_dto.dart';
import '../models/reset_password_response_model_dto.dart';

extension ResetPasswordRequestEntityMapper on ResetPasswordRequestEntity {
  ResetPasswordRequestModelDto toDto() {
    return ResetPasswordRequestModelDto(
      identifier: identifier.trim(),
      resetToken: resetToken.trim(),
      newPassword: newPassword,
    );
  }
}

extension ResetPasswordResponseDtoMapper on ResetPasswordResponseModelDto {
  ResetPasswordResponseEntity toEntity() {
    return ResetPasswordResponseEntity(message: message.trim());
  }
}
