import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';
import 'package:zadana_delivery/core/services/language_service.dart';

import '../models/driver_region_city_model_dto.dart';
import '../models/driver_region_model_dto.dart';
import '../models/driver_zone_model_dto.dart';
import 'driver_zones_remote_data_source.dart';

@Injectable(as: DriverZonesRemoteDataSource)
class DriverZonesRemoteDataSourceImpl implements DriverZonesRemoteDataSource {
  const DriverZonesRemoteDataSourceImpl(
    this._apiServices,
    this._languageService,
  );

  final ApiServices _apiServices;
  final LanguageService _languageService;

  @override
  Future<List<DriverZoneModelDto>> getZones() async {
    try {
      final regionsResponse = await _apiServices.getDriverZones();
      final regions =
          _normalizeList(
            regionsResponse,
          ).map(DriverRegionModelDto.fromJson).toList(growable: false)..sort(
            (first, second) => first.sortOrder.compareTo(second.sortOrder),
          );

      final citiesByRegion = await Future.wait(
        regions.map((region) async {
          final citiesResponse = await _apiServices.getDriverZoneCities(
            region.code,
          );
          final cities =
              _normalizeList(
                  citiesResponse,
                ).map(DriverRegionCityModelDto.fromJson).toList(growable: false)
                ..sort(
                  (first, second) =>
                      first.sortOrder.compareTo(second.sortOrder),
                );

          return cities
              .map(
                (city) => DriverZoneModelDto.localized(
                  id: city.code,
                  regionCode: region.code,
                  city: _localizedName(
                    nameAr: region.nameAr,
                    nameEn: region.nameEn,
                  ),
                  name: _localizedName(
                    nameAr: city.nameAr,
                    nameEn: city.nameEn,
                  ),
                  centerLat: city.latitude,
                  centerLng: city.longitude,
                  radiusKm: city.mapZoom.toDouble(),
                ),
              )
              .toList(growable: false);
        }),
      );

      return citiesByRegion.expand((cities) => cities).toList(growable: false);
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  String _localizedName({required String nameAr, required String nameEn}) {
    final languageCode = _languageService.getLanguageCode().toLowerCase();
    final localized = languageCode.startsWith('ar') ? nameAr : nameEn;
    if (localized.trim().isNotEmpty) {
      return localized.trim();
    }
    if (nameEn.trim().isNotEmpty) {
      return nameEn.trim();
    }
    return nameAr.trim();
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
