import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/auth/login/domain/entities/login_response_entity.dart';

import '../entities/resend_driver_otp_request_entity.dart';
import '../entities/resend_driver_otp_response_entity.dart';
import '../entities/verify_driver_otp_request_entity.dart';

abstract class DriverVerifyOtpRepository {
  Future<ApiResult<LoginResponseEntity>> verify(
    VerifyDriverOtpRequestEntity request,
  );

  Future<ApiResult<ResendDriverOtpResponseEntity>> resend(
    ResendDriverOtpRequestEntity request,
  );
}
