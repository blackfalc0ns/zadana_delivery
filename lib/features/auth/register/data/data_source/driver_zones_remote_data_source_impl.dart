import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';

import '../models/driver_zone_model_dto.dart';
import 'driver_zones_remote_data_source.dart';

@Injectable(as: DriverZonesRemoteDataSource)
class DriverZonesRemoteDataSourceImpl implements DriverZonesRemoteDataSource {
  const DriverZonesRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<List<DriverZoneModelDto>> getZones() async {
    try {
      final response = await _apiServices.getDriverZones();
      return _normalizeList(
        response,
      ).map(DriverZoneModelDto.fromJson).toList(growable: false);
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  List<Map<String, dynamic>> _normalizeList(dynamic response) {
    if (response is List) {
      return response
          .whereType<Map>()
          .map(Map<String, dynamic>.from)
          .toList(growable: false);
    }

    if (response is Map<String, dynamic>) {
      final items = response['data'] ?? response['items'] ?? response['zones'];
      if (items is List) {
        return items
            .whereType<Map>()
            .map(Map<String, dynamic>.from)
            .toList(growable: false);
      }
    }

    return const <Map<String, dynamic>>[];
  }
}
