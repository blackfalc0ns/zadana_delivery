import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';

import '../models/register_request_model_dto.dart';
import '../models/register_response_model_dto.dart';
import '../models/register_tokens_model_dto.dart';
import '../models/register_user_model_dto.dart';
import 'register_remote_data_source.dart';

@Injectable(as: RegisterRemoteDataSource)
class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  const RegisterRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<RegisterResponseModelDto> register(
    RegisterRequestModelDto request,
  ) async {
    try {
      final response = await _apiServices.registerDriver(request.toJson());
      return RegisterResponseModelDto.fromJson(
        _normalizeRegisterResponse(response),
      );
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  Map<String, dynamic> _normalizeRegisterResponse(dynamic response) {
    final map = _normalizeMap(response);
    final rawTokens = map['tokens'];
    final normalizedTokens = rawTokens is Map
        ? Map<String, dynamic>.from(rawTokens)
        : rawTokens == null
        ? null
        : <String, dynamic>{
            'accessToken': map['accessToken']?.toString(),
            'refreshToken': map['refreshToken']?.toString(),
          };

    final rawUser = map['user'];
    final normalizedUser = rawUser is Map
        ? Map<String, dynamic>.from(rawUser)
        : <String, dynamic>{
            'id': map['id']?.toString(),
            'fullName': map['fullName']?.toString(),
            'email': map['email']?.toString(),
            'phone': map['phone']?.toString(),
            'role': map['role']?.toString() ?? 'Driver',
            'profilePhotoUrl': map['profilePhotoUrl']?.toString(),
            'favoritesCount': map['favoritesCount'],
          };

    return {
      'tokens': normalizedTokens == null
          ? null
          : RegisterTokensModelDto.fromJson({
              'accessToken': normalizedTokens['accessToken']?.toString(),
              'refreshToken': normalizedTokens['refreshToken']?.toString(),
            }).toJson(),
      'user': RegisterUserModelDto.fromJson({
        'id': normalizedUser['id']?.toString(),
        'fullName': normalizedUser['fullName']?.toString(),
        'email': normalizedUser['email']?.toString(),
        'phone': normalizedUser['phone']?.toString(),
        'role': normalizedUser['role']?.toString() ?? 'Driver',
        'profilePhotoUrl': normalizedUser['profilePhotoUrl']?.toString(),
        'favoritesCount': normalizedUser['favoritesCount'] is int
            ? normalizedUser['favoritesCount']
            : 0,
      }).toJson(),
      'message': map['message']?.toString(),
      'isVerified': map['isVerified'] is bool ? map['isVerified'] : true,
      'driverStatus': map['driverStatus'],
    };
  }

  Map<String, dynamic> _normalizeMap(dynamic response) {
    if (response is Map<String, dynamic>) return response;
    if (response is Map) return Map<String, dynamic>.from(response);
    return const <String, dynamic>{};
  }
}
