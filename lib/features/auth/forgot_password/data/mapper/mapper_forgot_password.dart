import '../../domain/entities/forgot_password_request_entity.dart';
import '../../domain/entities/forgot_password_response_entity.dart';
import '../models/forgot_password_request_model_dto.dart';
import '../models/forgot_password_response_model_dto.dart';

extension ForgotPasswordRequestEntityMapper on ForgotPasswordRequestEntity {
  ForgotPasswordRequestModelDto toDto() {
    return ForgotPasswordRequestModelDto(identifier: identifier.trim());
  }
}

extension ForgotPasswordResponseDtoMapper on ForgotPasswordResponseModelDto {
  ForgotPasswordResponseEntity toEntity() {
    return ForgotPasswordResponseEntity(message: message.trim());
  }
}
