import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/login_request_entity.dart';
import '../entities/login_response_entity.dart';

abstract class LoginRepository {
  Future<ApiResult<LoginResponseEntity>> login(LoginRequestEntity request);
}
