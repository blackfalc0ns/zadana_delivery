import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/auth/login/domain/entities/login_response_entity.dart';

import '../entities/verify_driver_otp_request_entity.dart';
import '../repo/driver_verify_otp_repository.dart';

@injectable
class VerifyDriverOtpUseCase {
  const VerifyDriverOtpUseCase(this._repository);

  final DriverVerifyOtpRepository _repository;

  Future<ApiResult<LoginResponseEntity>> call(
    VerifyDriverOtpRequestEntity request,
  ) {
    return _repository.verify(request);
  }
}
