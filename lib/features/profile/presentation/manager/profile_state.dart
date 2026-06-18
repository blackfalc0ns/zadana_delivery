import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/driver_zone_entity.dart';
import 'package:zadana_delivery/features/profile/domain/entities/driver_unified_profile_entity.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_document_item_data.dart';

class ProfileState {
  const ProfileState({
    this.isLoading = false,
    this.isSaving = false,
    this.isRegionCitiesLoading = false,
    this.isSuccess = false,
    this.isLoggingOut = false,
    this.notificationsEnabled = true,
    this.profile,
    this.regionCities = const <DriverRegionCityEntity>[],
    this.documentPaths = const <String, String>{},
    this.failure,
    this.regionCitiesFailure,
    this.lastPickedDocumentType,
  });

  final bool isLoading;
  final bool isSaving;
  final bool isRegionCitiesLoading;
  final bool isSuccess;
  final bool isLoggingOut;
  final bool notificationsEnabled;
  final DriverUnifiedProfileEntity? profile;
  final List<DriverRegionCityEntity> regionCities;
  final Map<String, String> documentPaths;
  final Failure? failure;
  final Failure? regionCitiesFailure;
  final ProfileDocumentType? lastPickedDocumentType;

  ProfileState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isRegionCitiesLoading,
    bool? isSuccess,
    bool? isLoggingOut,
    bool? notificationsEnabled,
    DriverUnifiedProfileEntity? profile,
    List<DriverRegionCityEntity>? regionCities,
    Map<String, String>? documentPaths,
    Failure? failure,
    Failure? regionCitiesFailure,
    bool clearFailure = false,
    bool clearRegionCitiesFailure = false,
    ProfileDocumentType? lastPickedDocumentType,
    bool clearLastPickedDocumentType = false,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isRegionCitiesLoading:
          isRegionCitiesLoading ?? this.isRegionCitiesLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      profile: profile ?? this.profile,
      regionCities: regionCities ?? this.regionCities,
      documentPaths: documentPaths ?? this.documentPaths,
      failure: clearFailure ? null : failure ?? this.failure,
      regionCitiesFailure: clearRegionCitiesFailure
          ? null
          : regionCitiesFailure ?? this.regionCitiesFailure,
      lastPickedDocumentType: clearLastPickedDocumentType
          ? null
          : lastPickedDocumentType ?? this.lastPickedDocumentType,
    );
  }
}
