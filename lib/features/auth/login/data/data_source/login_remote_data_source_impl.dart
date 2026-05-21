import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';

import '../models/login_request_model_dto.dart';
import '../models/login_response_model_dto.dart';
import '../models/tokens_model_dto.dart';
import '../models/user_model_dto.dart';
import 'login_remote_data_source.dart';

@Injectable(as: LoginRemoteDataSource)
class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  const LoginRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<LoginResponseModelDto> login(LoginRequestModelDto request) async {
    try {
      final response = await _apiServices.loginDriver(request.toJson());
      return LoginResponseModelDto.fromJson(_normalizeLoginResponse(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  Map<String, dynamic> _normalizeLoginResponse(dynamic response) {
    final map = _normalizeMap(response);
    final rawTokens = map['tokens'];
    final normalizedTokens = rawTokens is Map
        ? Map<String, dynamic>.from(rawTokens)
        : <String, dynamic>{
            'accessToken': map['accessToken']?.toString() ?? '',
            'refreshToken': map['refreshToken']?.toString() ?? '',
          };

    final rawUser = map['user'];
    final normalizedUser = rawUser is Map
        ? Map<String, dynamic>.from(rawUser)
        : <String, dynamic>{
            'id': map['id']?.toString() ?? '',
            'fullName': map['fullName']?.toString() ?? '',
            'email': map['email']?.toString() ?? '',
            'phone': map['phone']?.toString() ?? '',
            'role': map['role']?.toString() ?? 'driver',
            'profilePhotoUrl': map['profilePhotoUrl']?.toString() ?? '',
            'favoritesCount': 0,
          };

    return {
      'tokens': TokensModelDto.fromJson({
        'accessToken': normalizedTokens['accessToken']?.toString() ?? '',
        'refreshToken': normalizedTokens['refreshToken']?.toString() ?? '',
      }).toJson(),
      'user': UserModelDto.fromJson({
        'id': normalizedUser['id']?.toString() ?? '',
        'fullName': normalizedUser['fullName']?.toString() ?? '',
        'email': normalizedUser['email']?.toString() ?? '',
        'phone': normalizedUser['phone']?.toString() ?? '',
        'role': normalizedUser['role']?.toString() ?? 'driver',
        'profilePhotoUrl': normalizedUser['profilePhotoUrl']?.toString() ?? '',
        'favoritesCount': normalizedUser['favoritesCount'] is int
            ? normalizedUser['favoritesCount']
            : 0,
      }).toJson(),
      'message': map['message']?.toString() ?? '',
      'isVerified': map['isVerified'] is bool ? map['isVerified'] : true,
      'driverStatus': _normalizeDriverStatus(map['driverStatus']),
    };
  }

  Map<String, dynamic>? _normalizeDriverStatus(dynamic rawDriverStatus) {
    if (rawDriverStatus is Map<String, dynamic>) return rawDriverStatus;
    if (rawDriverStatus is Map) {
      return Map<String, dynamic>.from(rawDriverStatus);
    }
    return null;
  }

  Map<String, dynamic> _normalizeMap(dynamic response) {
    if (response is Map<String, dynamic>) return response;
    if (response is Map) return Map<String, dynamic>.from(response);
    return const <String, dynamic>{};
  }
}
