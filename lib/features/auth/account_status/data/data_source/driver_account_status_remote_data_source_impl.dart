import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';

import '../models/driver_account_status_model_dto.dart';
import 'driver_account_status_remote_data_source.dart';

@Injectable(as: DriverAccountStatusRemoteDataSource)
class DriverAccountStatusRemoteDataSourceImpl
    implements DriverAccountStatusRemoteDataSource {
  const DriverAccountStatusRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<DriverAccountStatusModelDto> getStatus() async {
    try {
      final response = await _apiServices.getDriverStatus();
      return DriverAccountStatusModelDto.fromJson(_normalizeMap(response));
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
