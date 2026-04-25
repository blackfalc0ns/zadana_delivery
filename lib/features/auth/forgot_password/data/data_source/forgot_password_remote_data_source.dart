import '../models/forgot_password_request_model_dto.dart';
import '../models/forgot_password_response_model_dto.dart';

abstract class ForgotPasswordRemoteDataSource {
  Future<ForgotPasswordResponseModelDto> sendCode(
    ForgotPasswordRequestModelDto request,
  );
}
