import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';

import '../models/reset_password_request_model_dto.dart';
import '../models/reset_password_response_model_dto.dart';
import 'reset_password_remote_data_source.dart';

@Injectable(as: ResetPasswordRemoteDataSource)
class ResetPasswordRemoteDataSourceImpl
    implements ResetPasswordRemoteDataSource {
  const ResetPasswordRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<ResetPasswordResponseModelDto> reset(
    ResetPasswordRequestModelDto request,
  ) async {
    try {
      final response = await _apiServices.resetDriverPassword(request.toJson());
      return ResetPasswordResponseModelDto.fromJson(_normalizeMap(response));
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
