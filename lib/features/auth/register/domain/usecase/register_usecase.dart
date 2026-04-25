import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/register_request_entity.dart';
import '../entities/register_response_entity.dart';
import '../repo/register_repository.dart';

@injectable
class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final RegisterRepository _repository;

  Future<ApiResult<RegisterResponseEntity>> call(
    RegisterRequestEntity request,
  ) {
    return _repository.register(request);
  }
}
