import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';
import 'package:zadana_delivery/features/auth/login/data/models/login_response_model_dto.dart';
import 'package:zadana_delivery/features/auth/login/data/models/tokens_model_dto.dart';
import 'package:zadana_delivery/features/auth/login/data/models/user_model_dto.dart';

import '../models/resend_driver_otp_request_model_dto.dart';
import '../models/resend_driver_otp_response_model_dto.dart';
import '../models/verify_driver_otp_request_model_dto.dart';
import 'driver_verify_otp_remote_data_source.dart';

@Injectable(as: DriverVerifyOtpRemoteDataSource)
class DriverVerifyOtpRemoteDataSourceImpl
    implements DriverVerifyOtpRemoteDataSource {
  const DriverVerifyOtpRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<LoginResponseModelDto> verify(
    VerifyDriverOtpRequestModelDto request,
  ) async {
    try {
      final response = await _apiServices.verifyDriverOtp(request.toJson());
      return LoginResponseModelDto.fromJson(_normalizeLoginResponse(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<ResendDriverOtpResponseModelDto> resend(
    ResendDriverOtpRequestModelDto request,
  ) async {
    try {
      final response = await _apiServices.resendDriverOtp(request.toJson());
      final map = _normalizeMap(response);
      return ResendDriverOtpResponseModelDto(message: _extractMessage(map));
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

    return <String, dynamic>{
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

  String _extractMessage(Map<String, dynamic> map) {
    for (final key in ['message', 'message_ar', 'message_en']) {
      final value = map[key]?.toString().trim() ?? '';
      if (value.isNotEmpty) {
        return value;
      }
    }
    return '';
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
