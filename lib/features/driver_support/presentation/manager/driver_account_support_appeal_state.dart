import 'package:image_picker/image_picker.dart';
import 'package:zadana_delivery/core/models/localized_message.dart';
import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_reason_entity.dart';

enum DriverAccountSupportAppealUiError {
  reasonRequired,
  pickFiles,
  uploadFiles,
}

class DriverAccountSupportAppealState {
  const DriverAccountSupportAppealState({
    this.isLoadingReasons = false,
    this.isSubmitting = false,
    this.reasons = const <DriverSupportReasonEntity>[],
    this.selectedImages = const <XFile>[],
    this.selectedReasonCode,
    this.failure,
    this.successMessage,
    this.uiError,
  });

  final bool isLoadingReasons;
  final bool isSubmitting;
  final List<DriverSupportReasonEntity> reasons;
  final List<XFile> selectedImages;
  final String? selectedReasonCode;
  final Failure? failure;
  final LocalizedMessage? successMessage;
  final DriverAccountSupportAppealUiError? uiError;

  DriverAccountSupportAppealState copyWith({
    bool? isLoadingReasons,
    bool? isSubmitting,
    List<DriverSupportReasonEntity>? reasons,
    List<XFile>? selectedImages,
    String? selectedReasonCode,
    Failure? failure,
    LocalizedMessage? successMessage,
    DriverAccountSupportAppealUiError? uiError,
    bool clearSelectedReasonCode = false,
    bool clearFailure = false,
    bool clearSuccessMessage = false,
    bool clearUiError = false,
  }) {
    return DriverAccountSupportAppealState(
      isLoadingReasons: isLoadingReasons ?? this.isLoadingReasons,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      reasons: reasons ?? this.reasons,
      selectedImages: selectedImages ?? this.selectedImages,
      selectedReasonCode: clearSelectedReasonCode
          ? null
          : selectedReasonCode ?? this.selectedReasonCode,
      failure: clearFailure ? null : failure ?? this.failure,
      successMessage: clearSuccessMessage
          ? null
          : successMessage ?? this.successMessage,
      uiError: clearUiError ? null : uiError ?? this.uiError,
    );
  }
}
