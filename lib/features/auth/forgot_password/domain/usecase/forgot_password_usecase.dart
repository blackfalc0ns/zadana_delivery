import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/forgot_password_request_entity.dart';
import '../entities/forgot_password_response_entity.dart';
import '../repo/forgot_password_repository.dart';

@injectable
class ForgotPasswordUseCase {
  const ForgotPasswordUseCase(this._repository);

  final ForgotPasswordRepository _repository;

  Future<ApiResult<ForgotPasswordResponseEntity>> call(
    ForgotPasswordRequestEntity request,
  ) {
    return _repository.sendCode(request);
  }
}
