import '../models/register_request_model_dto.dart';
import '../models/register_response_model_dto.dart';

abstract class RegisterRemoteDataSource {
  Future<RegisterResponseModelDto> register(RegisterRequestModelDto request);
}
