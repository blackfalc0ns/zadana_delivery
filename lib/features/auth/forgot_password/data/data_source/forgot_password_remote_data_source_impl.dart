import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/network_constants.dart';
import 'package:zadana_delivery/core/services/token_interceptor.dart';

import '../models/forgot_password_request_model_dto.dart';
import '../models/forgot_password_response_model_dto.dart';
import 'forgot_password_remote_data_source.dart';

@Injectable(as: ForgotPasswordRemoteDataSource)
class ForgotPasswordRemoteDataSourceImpl
    implements ForgotPasswordRemoteDataSource {
  const ForgotPasswordRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<ForgotPasswordResponseModelDto> sendCode(
    ForgotPasswordRequestModelDto request,
  ) async {
    try {
      final headers = <String, dynamic>{};
      final token = request.botChallengeToken?.trim() ?? '';
      if (token.isNotEmpty) {
        headers['X-Bot-Challenge-Token'] = token;
      }

      final response = await _dio.post<dynamic>(
        EndPoints.driverForgotPassword,
        data: request.toJson(),
        options: Options(
          headers: headers,
          extra: {TokenInterceptor.skipAuthKey: true},
        ),
      );

      return ForgotPasswordResponseModelDto.fromJson(
        _normalizeMap(response.data),
      );
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
