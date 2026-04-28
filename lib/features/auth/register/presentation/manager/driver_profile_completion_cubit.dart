import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/utils/driver_vehicle_type.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/driver_zone_entity.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/register_request_entity.dart';
import 'package:zadana_delivery/features/auth/register/domain/usecase/register_usecase.dart';
import 'package:zadana_delivery/features/auth/register/presentation/manager/driver_profile_completion_state.dart';
import 'package:zadana_delivery/features/auth/register/presentation/models/register_account_draft.dart';
import 'package:zadana_delivery/features/auth/register/presentation/models/register_profile_draft.dart';
import 'package:zadana_delivery/features/profile/domain/entities/update_driver_documents_request_entity.dart';
import 'package:zadana_delivery/features/profile/domain/entities/update_driver_personal_request_entity.dart';
import 'package:zadana_delivery/features/profile/domain/entities/update_driver_vehicle_request_entity.dart';
import 'package:zadana_delivery/features/profile/domain/usecase/get_driver_unified_profile_usecase.dart';
import 'package:zadana_delivery/features/profile/domain/usecase/update_driver_documents_usecase.dart';
import 'package:zadana_delivery/features/profile/domain/usecase/update_driver_personal_usecase.dart';
import 'package:zadana_delivery/features/profile/domain/usecase/update_driver_vehicle_usecase.dart';

class DriverProfileCompletionCubit extends Cubit<DriverProfileCompletionState> {
  DriverProfileCompletionCubit({
    required RegisterUseCase registerUseCase,
    required GetDriverUnifiedProfileUseCase getProfileUseCase,
    required UpdateDriverPersonalUseCase updatePersonalUseCase,
    required UpdateDriverVehicleUseCase updateVehicleUseCase,
    required UpdateDriverDocumentsUseCase updateDocumentsUseCase,
    required ImagePicker imagePicker,
  }) : _registerUseCase = registerUseCase,
       _getProfileUseCase = getProfileUseCase,
       _updatePersonalUseCase = updatePersonalUseCase,
       _updateVehicleUseCase = updateVehicleUseCase,
       _updateDocumentsUseCase = updateDocumentsUseCase,
       _imagePicker = imagePicker,
       super(
         DriverProfileCompletionState(
           draft: _normalizeDraft(RegisterProfileDraft.empty),
         ),
       );

  final RegisterUseCase _registerUseCase;
  final GetDriverUnifiedProfileUseCase _getProfileUseCase;
  final UpdateDriverPersonalUseCase _updatePersonalUseCase;
  final UpdateDriverVehicleUseCase _updateVehicleUseCase;
  final UpdateDriverDocumentsUseCase _updateDocumentsUseCase;
  final ImagePicker _imagePicker;

  RegisterAccountDraft? _registrationDraft;

  bool get isProfileMode => _registrationDraft == null;

  Future<void> initialize({RegisterAccountDraft? registrationDraft}) async {
    if (state.isInitialized || state.isLoading) return;

    _registrationDraft = registrationDraft;

    if (!isProfileMode) {
      emit(
        state.copyWith(
          isInitialized: true,
          draft: _normalizeDraft(state.draft),
          clearFailure: true,
          clearSuccess: true,
          clearNavigation: true,
        ),
      );
      return;
    }

    await _loadUnifiedProfile();
  }

  void clearFailure() {
    if (state.failure == null) return;
    emit(state.copyWith(clearFailure: true));
  }

  void updateDraft(RegisterProfileDraft draft) {
    emit(
      state.copyWith(
        draft: _normalizeDraft(draft),
        clearFailure: true,
        clearSuccess: true,
        clearNavigation: true,
      ),
    );
  }

  void updateVehicleType(String value) {
    final normalized = value.trim().isEmpty
        ? ''
        : DriverVehicleType.normalize(value);
    updateDraft(state.draft.copyWith(vehicleType: normalized));
  }

  void updateZone(DriverZoneEntity zone) {
    updateDraft(
      state.draft.copyWith(
        zoneId: zone.id,
        zoneRegionCode: zone.regionCode,
        zoneName: zone.name,
        zoneCity: zone.city,
      ),
    );
  }

  Future<String?> pickImage({
    required String key,
    required String restartRequiredMessage,
    required String pickerErrorMessage,
  }) async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 86,
      );
      if (image == null) return null;

      final images = Map<String, String>.from(_normalizedImages(state.draft));
      images[key] = image.path;
      updateDraft(state.draft.copyWith(images: images));
      return null;
    } catch (error) {
      return error.toString().contains('channel-error')
          ? restartRequiredMessage
          : pickerErrorMessage;
    }
  }

  bool goBack() {
    if (state.currentStep == 0) return false;
    emit(state.copyWith(currentStep: state.currentStep - 1));
    return true;
  }

  Future<String?> goNext({
    required bool isFormValid,
    required String vehicleRequiredMessage,
    required String zoneRequiredMessage,
    required String imagesRequiredMessage,
    required String profileSuccessMessage,
  }) async {
    final validationMessage = _validateCurrentStep(
      isFormValid: isFormValid,
      vehicleRequiredMessage: vehicleRequiredMessage,
      zoneRequiredMessage: zoneRequiredMessage,
      imagesRequiredMessage: imagesRequiredMessage,
    );

    if (validationMessage != null) {
      return validationMessage;
    }

    if (state.currentStep < 3) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
      return null;
    }

    await _submit(profileSuccessMessage: profileSuccessMessage);
    return null;
  }

  Future<void> retry({required String profileSuccessMessage}) async {
    if (isProfileMode && state.fullName.trim().isEmpty) {
      await _loadUnifiedProfile();
      return;
    }

    await _submit(profileSuccessMessage: profileSuccessMessage);
  }

  String? _validateCurrentStep({
    required bool isFormValid,
    required String vehicleRequiredMessage,
    required String zoneRequiredMessage,
    required String imagesRequiredMessage,
  }) {
    final draft = _normalizeDraft(state.draft);

    if (state.currentStep == 1 && draft.vehicleType.trim().isEmpty) {
      return vehicleRequiredMessage;
    }

    if (state.currentStep == 1 && draft.zoneId.trim().isEmpty) {
      return zoneRequiredMessage;
    }

    if (state.currentStep == 2 || state.currentStep == 3) {
      if (!_hasRequiredImages(draft)) {
        return imagesRequiredMessage;
      }
      if (state.currentStep == 2) return null;
    }

    if (!isFormValid) return '';

    return null;
  }

  bool _hasRequiredImages(RegisterProfileDraft draft) {
    final requiredImages = _normalizedImages(draft);
    final requiredKeys = isProfileMode
        ? const ['portrait', 'idFront', 'license', 'vehicle']
        : const ['portrait', 'idFront', 'idBack', 'license', 'vehicle'];

    return requiredKeys.every((key) {
      final value = requiredImages[key] ?? '';
      final path = value.trim();
      return path.isNotEmpty &&
          (path.startsWith('http://') ||
              path.startsWith('https://') ||
              File(path).existsSync());
    });
  }

  Future<void> _loadUnifiedProfile() async {
    emit(
      state.copyWith(
        isLoading: true,
        clearFailure: true,
        clearSuccess: true,
        clearNavigation: true,
      ),
    );

    final result = await _getProfileUseCase.call();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isInitialized: true,
            isLoading: false,
            draft: _normalizeDraft(
              RegisterProfileDraft(
                vehicleType: result.data.vehicleType,
                zoneId: result.data.primaryZoneId,
                zoneRegionCode: '',
                zoneName: result.data.zoneName,
                zoneCity: '',
                address: result.data.address,
                nationalId: result.data.nationalId,
                licenseNumber: result.data.licenseNumber,
                images: {
                  'portrait': result.data.personalPhotoUrl,
                  'idFront': result.data.nationalIdImageUrl,
                  'idBack': '',
                  'license': result.data.licenseImageUrl,
                  'vehicle': result.data.vehicleImageUrl,
                },
              ),
            ),
            fullName: result.data.fullName,
            email: result.data.email,
            phone: result.data.phone,
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isInitialized: true,
            isLoading: false,
            failure: result.failure,
          ),
        );
    }
  }

  Future<void> _submit({required String profileSuccessMessage}) async {
    emit(
      state.copyWith(
        isLoading: true,
        clearFailure: true,
        clearSuccess: true,
        clearNavigation: true,
      ),
    );

    if (isProfileMode) {
      await _submitUnifiedProfileDraft(
        draft: _normalizeDraft(state.draft),
        profileSuccessMessage: profileSuccessMessage,
      );
      return;
    }

    await _submitRegisterDraft(draft: _normalizeDraft(state.draft));
  }

  Future<void> _submitRegisterDraft({
    required RegisterProfileDraft draft,
  }) async {
    final registrationDraft = _registrationDraft;
    if (registrationDraft == null) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    final result = await _registerUseCase.call(
      RegisterRequestEntity(
        fullName: registrationDraft.fullName,
        email: registrationDraft.email,
        phone: registrationDraft.phone,
        password: registrationDraft.password,
        vehicleType: draft.vehicleType,
        nationalId: draft.nationalId,
        licenseNumber: draft.licenseNumber,
        address: draft.address,
        region: draft.zoneRegionCode,
        city: draft.zoneId,
        nationalIdFrontImagePath: draft.images['idFront'] ?? '',
        nationalIdBackImagePath: draft.images['idBack'] ?? '',
        licenseImagePath: draft.images['license'] ?? '',
        vehicleImagePath: draft.images['vehicle'] ?? '',
        personalPhotoPath: draft.images['portrait'] ?? '',
      ),
    );

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            successMessage: result.data.message,
            targetRoute: AppRoutes.accountPendingApproval,
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isLoading: false, failure: result.failure));
    }
  }

  Future<void> _submitUnifiedProfileDraft({
    required RegisterProfileDraft draft,
    required String profileSuccessMessage,
  }) async {
    final personalResult = await _updatePersonalUseCase.call(
      UpdateDriverPersonalRequestEntity(
        fullName: state.fullName,
        email: state.email,
        phone: state.phone,
        address: draft.address,
      ),
    );

    if (personalResult case ApiErrorResult()) {
      emit(state.copyWith(isLoading: false, failure: personalResult.failure));
      return;
    }

    final vehicleResult = await _updateVehicleUseCase.call(
      UpdateDriverVehicleRequestEntity(
        vehicleType: draft.vehicleType,
        nationalId: draft.nationalId,
        licenseNumber: draft.licenseNumber,
        primaryZoneId: draft.zoneId,
      ),
    );

    if (vehicleResult case ApiErrorResult()) {
      emit(state.copyWith(isLoading: false, failure: vehicleResult.failure));
      return;
    }

    final documentsResult = await _updateDocumentsUseCase.call(
      UpdateDriverDocumentsRequestEntity(
        personalPhotoUrl: draft.images['portrait'] ?? '',
        nationalIdImageUrl: draft.images['idFront'] ?? '',
        licenseImageUrl: draft.images['license'] ?? '',
        vehicleImageUrl: draft.images['vehicle'] ?? '',
      ),
    );

    switch (documentsResult) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            successMessage: profileSuccessMessage,
            targetRoute: documentsResult.data.isPendingReview
                ? AppRoutes.accountPendingApproval
                : AppRoutes.mainShell,
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(isLoading: false, failure: documentsResult.failure),
        );
    }
  }

  static RegisterProfileDraft _normalizeDraft(RegisterProfileDraft draft) {
    return draft.copyWith(
      vehicleType: draft.vehicleType.trim().isEmpty
          ? ''
          : DriverVehicleType.normalize(draft.vehicleType),
      images: _normalizedImages(draft),
    );
  }

  static Map<String, String> _normalizedImages(RegisterProfileDraft draft) {
    return {
      'portrait': draft.images['portrait'] ?? '',
      'idFront': draft.images['idFront'] ?? '',
      'idBack': draft.images['idBack'] ?? '',
      'license': draft.images['license'] ?? '',
      'vehicle': draft.images['vehicle'] ?? '',
    };
  }
}
