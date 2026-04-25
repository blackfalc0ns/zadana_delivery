import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/register_request_entity.dart';
import '../entities/register_response_entity.dart';

abstract class RegisterRepository {
  Future<ApiResult<RegisterResponseEntity>> register(
    RegisterRequestEntity request,
  );
}
