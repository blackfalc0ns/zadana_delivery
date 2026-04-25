import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';

import '../models/auth_session_user_model_dto.dart';
import '../models/refresh_token_request_model_dto.dart';
import '../models/refresh_token_response_model_dto.dart';
import '../models/update_current_driver_request_model_dto.dart';
import 'auth_session_remote_data_source.dart';

@Injectable(as: AuthSessionRemoteDataSource)
class AuthSessionRemoteDataSourceImpl implements AuthSessionRemoteDataSource {
  const AuthSessionRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<AuthSessionUserModelDto> getCurrentDriver() async {
    try {
      final response = await _apiServices.getDriverProfile();
      return AuthSessionUserModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<AuthSessionUserModelDto> updateCurrentDriver(
    UpdateCurrentDriverRequestModelDto request,
  ) async {
    try {
      final response = await _apiServices.updateDriverProfile(request.toJson());
      return AuthSessionUserModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<RefreshTokenResponseModelDto> refreshToken(
    RefreshTokenRequestModelDto request,
  ) async {
    try {
      final response = await _apiServices.refreshDriverToken(request.toJson());
      return RefreshTokenResponseModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  Map<String, dynamic> _normalizeMap(dynamic response) {
    if (response is Map<String, dynamic>) return response;
    if (response is Map) return Map<String, dynamic>.from(response);
    return const <String, dynamic>{};
  }
}
