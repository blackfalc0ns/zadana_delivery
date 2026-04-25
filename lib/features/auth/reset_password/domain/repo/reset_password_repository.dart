import 'package:zadana_delivery/core/network/api_results.dart';

import '../entities/reset_password_request_entity.dart';
import '../entities/reset_password_response_entity.dart';

abstract class ResetPasswordRepository {
  Future<ApiResult<ResetPasswordResponseEntity>> reset(
    ResetPasswordRequestEntity request,
  );
}
