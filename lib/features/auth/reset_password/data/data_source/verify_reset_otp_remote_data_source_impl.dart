import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';

import '../models/verify_reset_otp_request_model_dto.dart';
import '../models/verify_reset_otp_response_model_dto.dart';
import 'verify_reset_otp_remote_data_source.dart';

@Injectable(as: VerifyResetOtpRemoteDataSource)
class VerifyResetOtpRemoteDataSourceImpl
    implements VerifyResetOtpRemoteDataSource {
  const VerifyResetOtpRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<VerifyResetOtpResponseModelDto> verify(
    VerifyResetOtpRequestModelDto request,
  ) async {
    try {
      final response = await _apiServices.verifyDriverResetOtp(request.toJson());
      return VerifyResetOtpResponseModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  Map<String, dynamic> _normalizeMap(dynamic response) {
    if (response is Map<String, dynamic>) return response;
    if (response is Map) return Map<String, dynamic>.from(response);
    return {'resetToken': response?.toString() ?? ''};
  }
}
