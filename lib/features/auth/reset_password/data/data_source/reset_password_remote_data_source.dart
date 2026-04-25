import '../models/reset_password_request_model_dto.dart';
import '../models/reset_password_response_model_dto.dart';

abstract class ResetPasswordRemoteDataSource {
  Future<ResetPasswordResponseModelDto> reset(
    ResetPasswordRequestModelDto request,
  );
}
