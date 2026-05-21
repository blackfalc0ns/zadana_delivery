import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/core/services/driver_notification_device_service.dart';
import 'package:zadana_delivery/features/auth/logout/domain/usecase/logout_usecase.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/driver_zone_entity.dart';
import 'package:zadana_delivery/features/auth/register/domain/usecase/get_driver_zones_usecase.dart';
import 'package:zadana_delivery/features/profile/domain/entities/update_driver_documents_request_entity.dart';
import 'package:zadana_delivery/features/profile/domain/entities/update_driver_personal_request_entity.dart';
import 'package:zadana_delivery/features/profile/domain/entities/update_driver_vehicle_request_entity.dart';
import 'package:zadana_delivery/features/profile/domain/usecase/get_driver_unified_profile_usecase.dart';
import 'package:zadana_delivery/features/profile/domain/usecase/update_driver_documents_usecase.dart';
import 'package:zadana_delivery/features/profile/domain/usecase/update_driver_personal_usecase.dart'
    show
        DeleteDriverProfilePhotoUseCase,
        UpdateDriverProfilePhotoUseCase,
        UpdateDriverPersonalUseCase;
import 'package:zadana_delivery/features/profile/domain/usecase/update_driver_vehicle_usecase.dart';

import '../models/profile_document_item_data.dart';
import 'profile_form_event.dart';
import 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(
    this._getProfileUseCase,
    this._logoutUseCase,
    this._updatePersonalUseCase,
    this._updateVehicleUseCase,
    this._updateDocumentsUseCase,
    this._updateProfilePhotoUseCase,
    this._deleteProfilePhotoUseCase,
    this._getDriverRegionsUseCase,
    this._picker,
  ) : super(const ProfileState());

  final GetDriverUnifiedProfileUseCase _getProfileUseCase;
  final LogoutUseCase _logoutUseCase;
  final UpdateDriverPersonalUseCase _updatePersonalUseCase;
  final UpdateDriverVehicleUseCase _updateVehicleUseCase;
  final UpdateDriverDocumentsUseCase _updateDocumentsUseCase;
  final UpdateDriverProfilePhotoUseCase _updateProfilePhotoUseCase;
  final DeleteDriverProfilePhotoUseCase _deleteProfilePhotoUseCase;
  final GetDriverRegionsUseCase _getDriverRegionsUseCase;
  final ImagePicker _picker;

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, clearFailure: true));
    final notificationsEnabled = await getIt<DriverNotificationDeviceService>()
        .isPushEnabled();

    final result = await _getProfileUseCase.call();
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            profile: result.data,
            documentPaths: {
              'portrait': result.data.personalPhotoUrl,
              'idFront': result.data.nationalIdFrontImageUrl,
              'idBack': result.data.nationalIdBackImageUrl,
              'license': result.data.licenseImageUrl,
              'vehicle': result.data.vehicleImageUrl,
            },
            notificationsEnabled: notificationsEnabled,
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isLoading: false, failure: result.failure));
    }
  }

  void updateNotifications(bool value) {
    if (state.notificationsEnabled == value) return;
    emit(state.copyWith(notificationsEnabled: value));
    unawaited(getIt<DriverNotificationDeviceService>().setPushEnabled(value));
  }

  Future<void> doIntent(ProfileFormEvent event) async {
    switch (event) {
      case ProfileFormLoadEvent():
        await _loadForm(includeRegionCities: event.includeRegionCities);
      case ProfileFormRetryRegionCitiesEvent():
        await _retryRegionCities();
      case ProfileFormSavePersonalEvent():
        await _savePersonal(event.request);
      case ProfileFormSaveVehicleEvent():
        await _saveVehicle(event.request);
      case ProfileFormPickDocumentEvent():
        await _pickDocument(event.type);
      case ProfileFormUpdateProfilePhotoEvent():
        await _updateProfilePhoto(event.photoPathOrUrl);
      case ProfileFormDeleteProfilePhotoEvent():
        await _deleteProfilePhoto();
      case ProfileFormSaveDocumentsEvent():
        await _saveDocuments();
      case ProfileFormClearErrorEvent():
        clearError();
    }
  }

  void clearError() {
    if (state.failure == null && state.regionCitiesFailure == null) return;
    emit(state.copyWith(clearFailure: true, clearRegionCitiesFailure: true));
  }

  Future<bool> logout() async {
    emit(state.copyWith(isLoggingOut: true, clearFailure: true));
    final result = await _logoutUseCase.call();

    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(isLoggingOut: false, clearFailure: true));
        return true;
      case ApiErrorResult():
        emit(state.copyWith(isLoggingOut: false, failure: result.failure));
        return false;
    }
  }

  Future<void> _loadForm({required bool includeRegionCities}) async {
    emit(
      state.copyWith(
        isLoading: true,
        isRegionCitiesLoading: includeRegionCities,
        isSuccess: false,
        clearFailure: true,
        clearRegionCitiesFailure: true,
      ),
    );

    final profileResult = await _getProfileUseCase.call();
    ApiResult<List<DriverRegionCityEntity>>? regionCitiesResult;
    if (includeRegionCities) {
      regionCitiesResult = await _getDriverRegionsUseCase.call();
    }

    final profile = switch (profileResult) {
      ApiSuccessResult() => profileResult.data,
      ApiErrorResult() => null,
    };
    final failure = switch (profileResult) {
      ApiSuccessResult() => null,
      ApiErrorResult() => profileResult.failure,
    };
    final regionCities = switch (regionCitiesResult) {
      ApiSuccessResult() => regionCitiesResult.data,
      ApiErrorResult() => const <DriverRegionCityEntity>[],
      null => state.regionCities,
    };
    final regionCitiesFailure = switch (regionCitiesResult) {
      ApiSuccessResult() => null,
      ApiErrorResult() => regionCitiesResult.failure,
      null => state.regionCitiesFailure,
    };

    emit(
      state.copyWith(
        isLoading: false,
        isRegionCitiesLoading: false,
        profile: profile,
        regionCities: regionCities,
        regionCitiesFailure: regionCitiesFailure,
        failure: failure,
        documentPaths: profile == null
            ? state.documentPaths
            : {
                'portrait': profile.personalPhotoUrl,
                'idFront': profile.nationalIdFrontImageUrl,
                'idBack': profile.nationalIdBackImageUrl,
                'license': profile.licenseImageUrl,
                'vehicle': profile.vehicleImageUrl,
              },
      ),
    );
  }

  Future<void> _retryRegionCities() async {
    emit(
      state.copyWith(
        isRegionCitiesLoading: true,
        clearRegionCitiesFailure: true,
      ),
    );
    final result = await _getDriverRegionsUseCase.call();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isRegionCitiesLoading: false,
            regionCities: result.data,
            clearRegionCitiesFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isRegionCitiesLoading: false,
            regionCitiesFailure: result.failure,
          ),
        );
    }
  }

  Future<void> _savePersonal(UpdateDriverPersonalRequestEntity request) async {
    emit(state.copyWith(isSaving: true, isSuccess: false, clearFailure: true));
    final result = await _updatePersonalUseCase.call(request);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isSaving: false,
            isSuccess: true,
            profile: result.data,
            documentPaths: {
              'portrait': result.data.personalPhotoUrl,
              'idFront': result.data.nationalIdFrontImageUrl,
              'idBack': result.data.nationalIdBackImageUrl,
              'license': result.data.licenseImageUrl,
              'vehicle': result.data.vehicleImageUrl,
            },
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isSaving: false,
            isSuccess: false,
            failure: result.failure,
          ),
        );
    }
  }

  Future<void> _saveVehicle(UpdateDriverVehicleRequestEntity request) async {
    emit(state.copyWith(isSaving: true, isSuccess: false, clearFailure: true));
    final result = await _updateVehicleUseCase.call(request);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isSaving: false,
            isSuccess: true,
            profile: result.data,
            documentPaths: {
              'portrait': result.data.personalPhotoUrl,
              'idFront': result.data.nationalIdFrontImageUrl,
              'idBack': result.data.nationalIdBackImageUrl,
              'license': result.data.licenseImageUrl,
              'vehicle': result.data.vehicleImageUrl,
            },
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isSaving: false,
            isSuccess: false,
            failure: result.failure,
          ),
        );
    }
  }

  Future<void> _pickDocument(ProfileDocumentType type) async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 86,
      );
      if (image == null) return;

      emit(
        state.copyWith(
          documentPaths: Map<String, String>.from(state.documentPaths)
            ..[type.storageKey] = image.path,
          clearFailure: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          failure: const Failure(
            errorMessage: 'driver_profile_picker_error',
            code: 'image_picker',
          ),
        ),
      );
    }
  }

  Future<void> _saveDocuments() async {
    final documentPaths = state.documentPaths;
    emit(state.copyWith(isSaving: true, isSuccess: false, clearFailure: true));

    final result = await _updateDocumentsUseCase.call(
      UpdateDriverDocumentsRequestEntity(
        personalPhotoUrl: documentPaths['portrait'] ?? '',
        nationalIdFrontImageUrl: documentPaths['idFront'] ?? '',
        nationalIdBackImageUrl: documentPaths['idBack'] ?? '',
        licenseImageUrl: documentPaths['license'] ?? '',
        vehicleImageUrl: documentPaths['vehicle'] ?? '',
      ),
    );

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isSaving: false,
            isSuccess: true,
            profile: result.data,
            documentPaths: {
              'portrait': result.data.personalPhotoUrl,
              'idFront': result.data.nationalIdFrontImageUrl,
              'idBack': result.data.nationalIdBackImageUrl,
              'license': result.data.licenseImageUrl,
              'vehicle': result.data.vehicleImageUrl,
            },
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isSaving: false,
            isSuccess: false,
            failure: result.failure,
          ),
        );
    }
  }

  Future<void> _updateProfilePhoto(String photoPathOrUrl) async {
    emit(state.copyWith(isSaving: true, isSuccess: false, clearFailure: true));
    final result = await _updateProfilePhotoUseCase.call(photoPathOrUrl);
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isSaving: false,
            isSuccess: false,
            profile: result.data,
            documentPaths: {
              ...state.documentPaths,
              'portrait': result.data.personalPhotoUrl,
            },
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isSaving: false,
            isSuccess: false,
            failure: result.failure,
          ),
        );
    }
  }

  Future<void> _deleteProfilePhoto() async {
    emit(state.copyWith(isSaving: true, isSuccess: false, clearFailure: true));
    final result = await _deleteProfilePhotoUseCase.call();
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isSaving: false,
            isSuccess: false,
            profile: result.data,
            documentPaths: {
              ...state.documentPaths,
              'portrait': result.data.personalPhotoUrl,
            },
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isSaving: false,
            isSuccess: false,
            failure: result.failure,
          ),
        );
    }
  }
}
