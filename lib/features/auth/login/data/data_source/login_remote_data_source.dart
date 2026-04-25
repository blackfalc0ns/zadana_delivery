import '../models/login_request_model_dto.dart';
import '../models/login_response_model_dto.dart';

abstract class LoginRemoteDataSource {
  Future<LoginResponseModelDto> login(LoginRequestModelDto request);
}
