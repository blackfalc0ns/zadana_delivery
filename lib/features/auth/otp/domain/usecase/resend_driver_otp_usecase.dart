import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/resend_driver_otp_request_entity.dart';
import '../entities/resend_driver_otp_response_entity.dart';
import '../repo/driver_verify_otp_repository.dart';

@injectable
class ResendDriverOtpUseCase {
  const ResendDriverOtpUseCase(this._repository);

  final DriverVerifyOtpRepository _repository;

  Future<ApiResult<ResendDriverOtpResponseEntity>> call(
    ResendDriverOtpRequestEntity request,
  ) {
    return _repository.resend(request);
  }
}
