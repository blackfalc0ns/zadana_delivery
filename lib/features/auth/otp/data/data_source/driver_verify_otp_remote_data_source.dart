import 'package:zadana_delivery/features/auth/login/data/models/login_response_model_dto.dart';

import '../models/resend_driver_otp_request_model_dto.dart';
import '../models/resend_driver_otp_response_model_dto.dart';
import '../models/verify_driver_otp_request_model_dto.dart';

abstract class DriverVerifyOtpRemoteDataSource {
  Future<LoginResponseModelDto> verify(VerifyDriverOtpRequestModelDto request);

  Future<ResendDriverOtpResponseModelDto> resend(
    ResendDriverOtpRequestModelDto request,
  );
}
