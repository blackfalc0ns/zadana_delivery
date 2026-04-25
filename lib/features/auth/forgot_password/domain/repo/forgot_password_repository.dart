import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/forgot_password_request_entity.dart';
import '../entities/forgot_password_response_entity.dart';

abstract class ForgotPasswordRepository {
  Future<ApiResult<ForgotPasswordResponseEntity>> sendCode(
    ForgotPasswordRequestEntity request,
  );
}
