import '../../domain/entities/verify_reset_otp_request_entity.dart';
import '../../domain/entities/verify_reset_otp_response_entity.dart';
import '../models/verify_reset_otp_request_model_dto.dart';
import '../models/verify_reset_otp_response_model_dto.dart';

extension VerifyResetOtpRequestEntityMapper on VerifyResetOtpRequestEntity {
  VerifyResetOtpRequestModelDto toDto() {
    return VerifyResetOtpRequestModelDto(
      identifier: identifier.trim(),
      otpCode: otpCode.trim(),
    );
  }
}

extension VerifyResetOtpResponseDtoMapper on VerifyResetOtpResponseModelDto {
  VerifyResetOtpResponseEntity toEntity() {
    return VerifyResetOtpResponseEntity(resetToken: resetToken);
  }
}
