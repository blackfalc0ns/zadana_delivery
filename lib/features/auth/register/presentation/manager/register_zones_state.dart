import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/driver_zone_entity.dart';

class RegisterZonesState {
  const RegisterZonesState({
    this.isLoading = false,
    this.zones = const <DriverZoneEntity>[],
    this.failure,
  });

  final bool isLoading;
  final List<DriverZoneEntity> zones;
  final Failure? failure;

  RegisterZonesState copyWith({
    bool? isLoading,
    List<DriverZoneEntity>? zones,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return RegisterZonesState(
      isLoading: isLoading ?? this.isLoading,
      zones: zones ?? this.zones,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}
