import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/services/language_service.dart';

import '../../domain/entities/driver_region_entity.dart';
import '../../domain/entities/driver_zone_entity.dart';
import '../../domain/repo/driver_zones_repository.dart';
import '../data_source/driver_zones_remote_data_source.dart';
import '../mapper/driver_zone_mapper.dart';

@Injectable(as: DriverRegionsRepository)
class DriverRegionsRepositoryImpl implements DriverRegionsRepository {
  const DriverRegionsRepositoryImpl(
    this._remoteDataSource,
    this._languageService,
  );

  final DriverRegionsRemoteDataSource _remoteDataSource;
  final LanguageService _languageService;

  @override
  Future<ApiResult<List<DriverRegionCityEntity>>> getRegionCities() {
    return safeApiCall(() async {
      final regionCities = await _remoteDataSource.getRegionCities();
      return regionCities
          .map((item) => item.toEntity())
          .where((item) => item.isActive)
          .toList(growable: false);
    });
  }

  @override
  Future<ApiResult<List<DriverRegionEntity>>> getRegions() {
    return safeApiCall(() async {
      final regions = await _remoteDataSource.getRegions();
      return regions
          .map(
            (item) => DriverRegionEntity(
              code: item.code,
              name: _localizedName(nameAr: item.nameAr, nameEn: item.nameEn),
            ),
          )
          .toList(growable: false);
    });
  }

  @override
  Future<ApiResult<List<DriverRegionCityEntity>>> getCitiesByRegion(
    String regionCode,
    String regionName,
  ) {
    return safeApiCall(() async {
      final cities = await _remoteDataSource.getCitiesByRegion(regionCode);
      return cities
          .map(
            (item) => item.toEntity().copyWith(regionName: regionName),
          )
          .where((item) => item.isActive)
          .toList(growable: false);
    });
  }

  String _localizedName({required String nameAr, required String nameEn}) {
    final languageCode = _languageService.getLanguageCode().toLowerCase();
    final localized = languageCode.startsWith('ar') ? nameAr : nameEn;
    if (localized.trim().isNotEmpty) return localized.trim();
    if (nameEn.trim().isNotEmpty) return nameEn.trim();
    return nameAr.trim();
  }
}
