import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/reset_password_request_entity.dart';
import '../entities/reset_password_response_entity.dart';
import '../repo/reset_password_repository.dart';

@injectable
class ResetPasswordUseCase {
  const ResetPasswordUseCase(this._repository);

  final ResetPasswordRepository _repository;

  Future<ApiResult<ResetPasswordResponseEntity>> call(
    ResetPasswordRequestEntity request,
  ) {
    return _repository.reset(request);
  }
}
