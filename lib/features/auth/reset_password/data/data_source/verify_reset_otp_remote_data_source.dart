import '../models/verify_reset_otp_request_model_dto.dart';
import '../models/verify_reset_otp_response_model_dto.dart';

abstract class VerifyResetOtpRemoteDataSource {
  Future<VerifyResetOtpResponseModelDto> verify(
    VerifyResetOtpRequestModelDto request,
  );
}
