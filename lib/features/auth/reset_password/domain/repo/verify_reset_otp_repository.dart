import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/verify_reset_otp_request_entity.dart';
import '../entities/verify_reset_otp_response_entity.dart';

abstract class VerifyResetOtpRepository {
  Future<ApiResult<VerifyResetOtpResponseEntity>> verify(
    VerifyResetOtpRequestEntity request,
  );
}
