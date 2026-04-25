import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/auth/logout/domain/usecase/logout_usecase.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/driver_zone_entity.dart';
import 'package:zadana_delivery/features/auth/register/domain/usecase/get_driver_zones_usecase.dart';
import 'package:zadana_delivery/features/profile/domain/entities/update_driver_documents_request_entity.dart';
import 'package:zadana_delivery/features/profile/domain/entities/update_driver_personal_request_entity.dart';
import 'package:zadana_delivery/features/profile/domain/entities/update_driver_vehicle_request_entity.dart';
import 'package:zadana_delivery/features/profile/domain/usecase/get_driver_unified_profile_usecase.dart';
import 'package:zadana_delivery/features/profile/domain/usecase/update_driver_documents_usecase.dart';
import 'package:zadana_delivery/features/profile/domain/usecase/update_driver_personal_usecase.dart';
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
    this._getDriverZonesUseCase,
    this._picker,
  ) : super(const ProfileState());

  final GetDriverUnifiedProfileUseCase _getProfileUseCase;
  final LogoutUseCase _logoutUseCase;
  final UpdateDriverPersonalUseCase _updatePersonalUseCase;
  final UpdateDriverVehicleUseCase _updateVehicleUseCase;
  final UpdateDriverDocumentsUseCase _updateDocumentsUseCase;
  final GetDriverZonesUseCase _getDriverZonesUseCase;
  final ImagePicker _picker;

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, clearFailure: true));

    final result = await _getProfileUseCase.call();
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            profile: result.data,
            documentPaths: {
              'portrait': result.data.personalPhotoUrl,
              'idFront': result.data.nationalIdImageUrl,
              'license': result.data.licenseImageUrl,
              'vehicle': result.data.vehicleImageUrl,
            },
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
  }

  Future<void> doIntent(ProfileFormEvent event) async {
    switch (event) {
      case ProfileFormLoadEvent():
        await _loadForm(includeZones: event.includeZones);
      case ProfileFormRetryZonesEvent():
        await _retryZones();
      case ProfileFormSavePersonalEvent():
        await _savePersonal(event.request);
      case ProfileFormSaveVehicleEvent():
        await _saveVehicle(event.request);
      case ProfileFormPickDocumentEvent():
        await _pickDocument(event.type);
      case ProfileFormSaveDocumentsEvent():
        await _saveDocuments();
      case ProfileFormClearErrorEvent():
        clearError();
    }
  }

  void clearError() {
    if (state.failure == null && state.zonesFailure == null) return;
    emit(state.copyWith(clearFailure: true, clearZonesFailure: true));
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

  Future<void> _loadForm({required bool includeZones}) async {
    emit(
      state.copyWith(
        isLoading: true,
        isZonesLoading: includeZones,
        isSuccess: false,
        clearFailure: true,
        clearZonesFailure: true,
      ),
    );

    final profileResult = await _getProfileUseCase.call();
    ApiResult<List<DriverZoneEntity>>? zonesResult;
    if (includeZones) {
      zonesResult = await _getDriverZonesUseCase.call();
    }

    final profile = switch (profileResult) {
      ApiSuccessResult() => profileResult.data,
      ApiErrorResult() => null,
    };
    final failure = switch (profileResult) {
      ApiSuccessResult() => null,
      ApiErrorResult() => profileResult.failure,
    };
    final zones = switch (zonesResult) {
      ApiSuccessResult() => zonesResult.data,
      ApiErrorResult() => const <DriverZoneEntity>[],
      null => state.zones,
    };
    final zonesFailure = switch (zonesResult) {
      ApiSuccessResult() => null,
      ApiErrorResult() => zonesResult.failure,
      null => state.zonesFailure,
    };

    emit(
      state.copyWith(
        isLoading: false,
        isZonesLoading: false,
        profile: profile,
        zones: zones,
        zonesFailure: zonesFailure,
        failure: failure,
        documentPaths: profile == null
            ? state.documentPaths
            : {
                'portrait': profile.personalPhotoUrl,
                'idFront': profile.nationalIdImageUrl,
                'license': profile.licenseImageUrl,
                'vehicle': profile.vehicleImageUrl,
              },
      ),
    );
  }

  Future<void> _retryZones() async {
    emit(state.copyWith(isZonesLoading: true, clearZonesFailure: true));
    final result = await _getDriverZonesUseCase.call();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isZonesLoading: false,
            zones: result.data,
            clearZonesFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isZonesLoading: false, zonesFailure: result.failure),
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
              'idFront': result.data.nationalIdImageUrl,
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
              'idFront': result.data.nationalIdImageUrl,
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
        nationalIdImageUrl: documentPaths['idFront'] ?? '',
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
              'idFront': result.data.nationalIdImageUrl,
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
}
