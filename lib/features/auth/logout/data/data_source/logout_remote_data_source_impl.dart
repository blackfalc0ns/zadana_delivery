import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';

import 'logout_remote_data_source.dart';

@Injectable(as: LogoutRemoteDataSource)
class LogoutRemoteDataSourceImpl implements LogoutRemoteDataSource {
  const LogoutRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<void> logout(String refreshToken) async {
    try {
      await _apiServices.logoutDriver({'refreshToken': refreshToken});
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }
}
