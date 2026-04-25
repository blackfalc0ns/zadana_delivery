import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/login_request_entity.dart';
import '../entities/login_response_entity.dart';
import '../repo/login_repository.dart';

@injectable
class LoginUseCase {
  const LoginUseCase(this._repository);

  final LoginRepository _repository;

  Future<ApiResult<LoginResponseEntity>> call(LoginRequestEntity request) {
    return _repository.login(request);
  }
}
