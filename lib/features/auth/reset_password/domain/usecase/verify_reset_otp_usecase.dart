import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/verify_reset_otp_request_entity.dart';
import '../entities/verify_reset_otp_response_entity.dart';
import '../repo/verify_reset_otp_repository.dart';

@injectable
class VerifyResetOtpUseCase {
  const VerifyResetOtpUseCase(this._repository);

  final VerifyResetOtpRepository _repository;

  Future<ApiResult<VerifyResetOtpResponseEntity>> call(
    VerifyResetOtpRequestEntity request,
  ) {
    return _repository.verify(request);
  }
}
