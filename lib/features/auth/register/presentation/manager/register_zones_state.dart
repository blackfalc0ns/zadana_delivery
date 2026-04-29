import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/driver_zone_entity.dart';

class RegisterRegionsState {
  const RegisterRegionsState({
    this.isLoading = false,
    this.regionCities = const <DriverRegionCityEntity>[],
    this.failure,
  });

  final bool isLoading;
  final List<DriverRegionCityEntity> regionCities;
  final Failure? failure;

  RegisterRegionsState copyWith({
    bool? isLoading,
    List<DriverRegionCityEntity>? regionCities,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return RegisterRegionsState(
      isLoading: isLoading ?? this.isLoading,
      regionCities: regionCities ?? this.regionCities,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}
