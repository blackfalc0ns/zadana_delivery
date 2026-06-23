import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';
import 'package:zadana_delivery/core/services/language_service.dart';

import '../models/driver_region_city_model_dto.dart';
import '../models/driver_region_model_dto.dart';
import '../models/driver_zone_model_dto.dart';
import 'driver_zones_remote_data_source.dart';

@Injectable(as: DriverRegionsRemoteDataSource)
class DriverRegionsRemoteDataSourceImpl
    implements DriverRegionsRemoteDataSource {
  const DriverRegionsRemoteDataSourceImpl(
    this._apiServices,
    this._languageService,
  );

  final ApiServices _apiServices;
  final LanguageService _languageService;

  @override
  Future<List<DriverRegionCityModelDto>> getRegionCities() async {
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
              _normalizeList(citiesResponse)
                  .map(DriverRegionCityApiModelDto.fromJson)
                  .toList(growable: false)
                ..sort(
                  (first, second) =>
                      first.sortOrder.compareTo(second.sortOrder),
                );

          return cities
              .map(
                (city) => DriverRegionCityModelDto.localized(
                  id: city.code,
                  regionCode: region.code,
                  regionName: _localizedName(
                    nameAr: region.nameAr,
                    nameEn: region.nameEn,
                  ),
                  cityName: _localizedName(
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

  @override
  Future<List<DriverRegionModelDto>> getRegions() async {
    try {
      final regionsResponse = await _apiServices.getDriverZones();
      return _normalizeList(regionsResponse)
          .map(DriverRegionModelDto.fromJson)
          .toList(growable: false)
        ..sort((first, second) => first.sortOrder.compareTo(second.sortOrder));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<List<DriverRegionCityModelDto>> getCitiesByRegion(
    String regionCode,
  ) async {
    try {
      final citiesResponse = await _apiServices.getDriverZoneCities(regionCode);
      final cities = _normalizeList(citiesResponse)
          .map(DriverRegionCityApiModelDto.fromJson)
          .toList(growable: false)
        ..sort((first, second) => first.sortOrder.compareTo(second.sortOrder));

      // We need the region name — fetch it from the regions list if needed
      // For simplicity, use the regionCode as we'll resolve the name at the selector level
      return cities
          .map(
            (city) => DriverRegionCityModelDto.localized(
              id: city.code,
              regionCode: regionCode,
              regionName: '', // resolved at repository level
              cityName: _localizedName(
                nameAr: city.nameAr,
                nameEn: city.nameEn,
              ),
              centerLat: city.latitude,
              centerLng: city.longitude,
              radiusKm: city.mapZoom.toDouble(),
            ),
          )
          .toList(growable: false);
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
      final items =
          response['data'] ?? response['items'] ?? response['regions'];
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
