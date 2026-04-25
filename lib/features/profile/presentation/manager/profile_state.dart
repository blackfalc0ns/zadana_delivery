import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/driver_zone_entity.dart';
import 'package:zadana_delivery/features/profile/domain/entities/driver_unified_profile_entity.dart';

class ProfileState {
  const ProfileState({
    this.isLoading = false,
    this.isSaving = false,
    this.isZonesLoading = false,
    this.isSuccess = false,
    this.isLoggingOut = false,
    this.notificationsEnabled = true,
    this.profile,
    this.zones = const <DriverZoneEntity>[],
    this.documentPaths = const <String, String>{},
    this.failure,
    this.zonesFailure,
  });

  final bool isLoading;
  final bool isSaving;
  final bool isZonesLoading;
  final bool isSuccess;
  final bool isLoggingOut;
  final bool notificationsEnabled;
  final DriverUnifiedProfileEntity? profile;
  final List<DriverZoneEntity> zones;
  final Map<String, String> documentPaths;
  final Failure? failure;
  final Failure? zonesFailure;

  ProfileState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isZonesLoading,
    bool? isSuccess,
    bool? isLoggingOut,
    bool? notificationsEnabled,
    DriverUnifiedProfileEntity? profile,
    List<DriverZoneEntity>? zones,
    Map<String, String>? documentPaths,
    Failure? failure,
    Failure? zonesFailure,
    bool clearFailure = false,
    bool clearZonesFailure = false,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isZonesLoading: isZonesLoading ?? this.isZonesLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      profile: profile ?? this.profile,
      zones: zones ?? this.zones,
      documentPaths: documentPaths ?? this.documentPaths,
      failure: clearFailure ? null : failure ?? this.failure,
      zonesFailure: clearZonesFailure ? null : zonesFailure ?? this.zonesFailure,
    );
  }
}
