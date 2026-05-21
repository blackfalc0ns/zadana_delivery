import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/services/file_upload_service.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_attachment_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_message_request_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/usecase/create_driver_account_appeal_usecase.dart';
import 'package:zadana_delivery/features/driver_support/domain/usecase/create_public_driver_account_appeal_usecase.dart';
import 'package:zadana_delivery/features/driver_support/domain/usecase/get_driver_support_reasons_usecase.dart';
import 'package:zadana_delivery/features/driver_support/presentation/manager/driver_account_support_appeal_state.dart';
import 'package:zadana_delivery/features/driver_support/presentation/models/driver_account_support_appeal_args.dart';
@injectable
class DriverAccountSupportAppealCubit
    extends Cubit<DriverAccountSupportAppealState> {
  DriverAccountSupportAppealCubit(
    this._imagePicker,
    this._fileUploadService,
    this._getReasonsUseCase,
    this._createAppealUseCase,
    this._createPublicAppealUseCase,
  ) : super(const DriverAccountSupportAppealState());

  final ImagePicker _imagePicker;
  final FileUploadService _fileUploadService;
  final GetDriverSupportReasonsUseCase _getReasonsUseCase;
  final CreateDriverAccountAppealUseCase _createAppealUseCase;
  final CreatePublicDriverAccountAppealUseCase _createPublicAppealUseCase;

  DriverAccountSupportAppealArgs? _args;

  Future<void> initialize(DriverAccountSupportAppealArgs? args) async {
    _args = args;
    await loadReasons();
  }

  Future<void> loadReasons() async {
    emit(
      state.copyWith(
        isLoadingReasons: true,
        clearFailure: true,
        clearUiError: true,
      ),
    );

    final result = await _getReasonsUseCase.call('driver_account');
    switch (result) {
      case ApiSuccessResult():
        final reasons = result.data;
        final preferredCode = _args?.initialReasonCode?.trim() ?? '';
        final currentCode = state.selectedReasonCode?.trim() ?? '';
        final fallbackCode = currentCode.isNotEmpty
            ? currentCode
            : preferredCode;
        final resolvedCode =
            reasons.any((item) => item.code.trim() == fallbackCode)
            ? fallbackCode
            : reasons.isNotEmpty
            ? reasons.first.code
            : null;

        emit(
          state.copyWith(
            isLoadingReasons: false,
            reasons: reasons,
            selectedReasonCode: resolvedCode,
            clearFailure: true,
            clearUiError: true,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isLoadingReasons: false, failure: result.failure));
    }
  }

  void selectReason(String code) {
    final normalizedCode = code.trim();
    if (normalizedCode.isEmpty || normalizedCode == state.selectedReasonCode) {
      return;
    }
    emit(
      state.copyWith(selectedReasonCode: normalizedCode, clearUiError: true),
    );
  }

  Future<void> pickImages() async {
    if (state.isSubmitting) return;

    try {
      final images = await _imagePicker.pickMultiImage(imageQuality: 82);
      if (images.isEmpty) return;

      final existingPaths = state.selectedImages
          .map((item) => item.path)
          .toSet();
      final merged = List<XFile>.from(state.selectedImages);
      for (final image in images) {
        if (existingPaths.add(image.path)) {
          merged.add(image);
        }
      }

      emit(state.copyWith(selectedImages: merged, clearUiError: true));
    } catch (_) {
      emit(
        state.copyWith(uiError: DriverAccountSupportAppealUiError.pickFiles),
      );
    }
  }

  void removeImage(XFile image) {
    if (state.isSubmitting) return;
    emit(
      state.copyWith(
        selectedImages: state.selectedImages
            .where((item) => item.path != image.path)
            .toList(growable: false),
      ),
    );
  }

  Future<void> submit({
    required bool requiresAuthentication,
    required String identifier,
    required String message,
  }) async {
    if (state.isSubmitting) return;

    final reasonCode = (state.selectedReasonCode ?? '').trim();
    if (reasonCode.isEmpty) {
      emit(
        state.copyWith(
          uiError: DriverAccountSupportAppealUiError.reasonRequired,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isSubmitting: true,
        clearFailure: true,
        clearSuccessMessage: true,
        clearUiError: true,
      ),
    );

    try {
      final attachments = await _uploadSelectedImages();
      final request = DriverSupportCaseMessageRequestEntity(
        reasonCode: reasonCode,
        message: message.trim(),
        attachments: attachments,
      );

      final result = requiresAuthentication
          ? await _createAppealUseCase.call(request: request)
          : await _createPublicAppealUseCase.call(
              identifier: identifier.trim(),
              request: request,
            );

      switch (result) {
        case ApiSuccessResult():
          emit(
            state.copyWith(
              isSubmitting: false,
              selectedImages: const <XFile>[],
              successMessage: result.data,
              clearFailure: true,
              clearUiError: true,
            ),
          );
        case ApiErrorResult():
          emit(state.copyWith(isSubmitting: false, failure: result.failure));
      }
    } catch (_) {
      emit(state.copyWith(isSubmitting: false));
    }
  }

  void clearFeedback() {
    if (state.failure == null &&
        state.successMessage == null &&
        state.uiError == null) {
      return;
    }

    emit(
      state.copyWith(
        clearFailure: true,
        clearSuccessMessage: true,
        clearUiError: true,
      ),
    );
  }

  Future<List<DriverSupportAttachmentEntity>> _uploadSelectedImages() async {
    if (state.selectedImages.isEmpty) {
      return const <DriverSupportAttachmentEntity>[];
    }

    try {
      final attachments = <DriverSupportAttachmentEntity>[];
      for (final image in state.selectedImages) {
        final url = await _fileUploadService.uploadFile(
          image.path,
          directory: DriverUploadDirectory.proofs,
        );
        final file = File(image.path);
        final fileName = file.uri.pathSegments.isEmpty
            ? 'attachment.jpg'
            : file.uri.pathSegments.last;
        attachments.add(
          DriverSupportAttachmentEntity(fileName: fileName, fileUrl: url),
        );
      }
      return attachments;
    } catch (_) {
      emit(
        state.copyWith(
          isSubmitting: false,
          uiError: DriverAccountSupportAppealUiError.uploadFiles,
        ),
      );
      rethrow;
    }
  }
}
