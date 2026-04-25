import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';

import '../models/forgot_password_request_model_dto.dart';
import '../models/forgot_password_response_model_dto.dart';
import 'forgot_password_remote_data_source.dart';

@Injectable(as: ForgotPasswordRemoteDataSource)
class ForgotPasswordRemoteDataSourceImpl
    implements ForgotPasswordRemoteDataSource {
  const ForgotPasswordRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<ForgotPasswordResponseModelDto> sendCode(
    ForgotPasswordRequestModelDto request,
  ) async {
    try {
      final response = await _apiServices.forgotDriverPassword(
        request.toJson(),
      );
      return ForgotPasswordResponseModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  Map<String, dynamic> _normalizeMap(dynamic response) {
    if (response is Map<String, dynamic>) return response;
    if (response is Map) return Map<String, dynamic>.from(response);
    return {'message': response?.toString() ?? ''};
  }
}
