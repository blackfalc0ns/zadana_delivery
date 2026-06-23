import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/driver_zone_entity.dart';

import '../../domain/usecase/get_driver_zones_usecase.dart';
import '../../domain/usecase/get_region_cities_usecase.dart';
import '../../domain/usecase/get_regions_usecase.dart';
import 'register_zones_state.dart';

@injectable
class RegisterRegionsCubit extends Cubit<RegisterRegionsState> {
  RegisterRegionsCubit(
    this._getDriverRegionsUseCase,
    this._getRegionsUseCase,
    this._getRegionCitiesUseCase,
  ) : super(const RegisterRegionsState());

  final GetDriverRegionsUseCase _getDriverRegionsUseCase;
  final GetRegionsUseCase _getRegionsUseCase;
  final GetRegionCitiesUseCase _getRegionCitiesUseCase;

  /// Cache cities per region to avoid re-fetching.
  final Map<String, List<DriverRegionCityEntity>> _citiesCache = {};

  /// Legacy method — loads all regions + cities in one shot.
  Future<void> loadRegionCities() async {
    emit(state.copyWith(isLoading: true, clearFailure: true));
    final result = await _getDriverRegionsUseCase.call();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            regionCities: result.data,
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isLoading: false, failure: result.failure));
    }
  }

  /// New: loads regions only.
  Future<void> loadRegions() async {
    emit(state.copyWith(isLoading: true, clearFailure: true));
    final result = await _getRegionsUseCase.call();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            regions: result.data,
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isLoading: false, failure: result.failure));
    }
  }

  /// New: loads cities for a selected region.
  Future<void> loadCitiesForRegion({
    required String regionCode,
    required String regionName,
  }) async {
    // Return from cache if available.
    final cached = _citiesCache[regionCode];
    if (cached != null) {
      emit(
        state.copyWith(
          regionCities: cached,
          selectedRegionCode: regionCode,
          isCitiesLoading: false,
          clearCitiesFailure: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isCitiesLoading: true,
        selectedRegionCode: regionCode,
        regionCities: const <DriverRegionCityEntity>[],
        clearCitiesFailure: true,
      ),
    );

    final result = await _getRegionCitiesUseCase.call(
      regionCode: regionCode,
      regionName: regionName,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        _citiesCache[regionCode] = result.data;
        emit(
          state.copyWith(
            isCitiesLoading: false,
            regionCities: result.data,
            clearCitiesFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isCitiesLoading: false,
            citiesFailure: result.failure,
          ),
        );
    }
  }
}
