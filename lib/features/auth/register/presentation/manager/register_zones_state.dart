import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/driver_region_entity.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/driver_zone_entity.dart';

class RegisterRegionsState {
  const RegisterRegionsState({
    this.isLoading = false,
    this.isCitiesLoading = false,
    this.regions = const <DriverRegionEntity>[],
    this.regionCities = const <DriverRegionCityEntity>[],
    this.selectedRegionCode = '',
    this.failure,
    this.citiesFailure,
  });

  final bool isLoading;
  final bool isCitiesLoading;
  final List<DriverRegionEntity> regions;
  final List<DriverRegionCityEntity> regionCities;
  final String selectedRegionCode;
  final Failure? failure;
  final Failure? citiesFailure;

  RegisterRegionsState copyWith({
    bool? isLoading,
    bool? isCitiesLoading,
    List<DriverRegionEntity>? regions,
    List<DriverRegionCityEntity>? regionCities,
    String? selectedRegionCode,
    Failure? failure,
    Failure? citiesFailure,
    bool clearFailure = false,
    bool clearCitiesFailure = false,
  }) {
    return RegisterRegionsState(
      isLoading: isLoading ?? this.isLoading,
      isCitiesLoading: isCitiesLoading ?? this.isCitiesLoading,
      regions: regions ?? this.regions,
      regionCities: regionCities ?? this.regionCities,
      selectedRegionCode: selectedRegionCode ?? this.selectedRegionCode,
      failure: clearFailure ? null : failure ?? this.failure,
      citiesFailure:
          clearCitiesFailure ? null : citiesFailure ?? this.citiesFailure,
    );
  }
}
