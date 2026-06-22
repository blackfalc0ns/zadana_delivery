import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/auth/otp/domain/entities/resend_driver_otp_request_entity.dart';
import 'package:zadana_delivery/features/auth/otp/domain/usecase/resend_driver_otp_usecase.dart';

import '../../domain/entities/verify_reset_otp_request_entity.dart';
import '../../domain/usecase/verify_reset_otp_usecase.dart';
import 'verify_reset_otp_event.dart';
import 'verify_reset_otp_state.dart';

@injectable
class VerifyResetOtpViewModel extends Cubit<VerifyResetOtpState> {
  VerifyResetOtpViewModel(
    this._verifyResetOtpUseCase,
    this._resendDriverOtpUseCase,
  ) : super(const VerifyResetOtpState());

  final VerifyResetOtpUseCase _verifyResetOtpUseCase;
  final ResendDriverOtpUseCase _resendDriverOtpUseCase;

  Future<void> doIntent(VerifyResetOtpEvent event) async {
    switch (event) {
      case VerifyResetOtpSubmitEvent():
        await _verify(event.request);
      case VerifyResetOtpResendEvent():
        await _resendCode(event.identifier);
    }
  }

  void clearError() {
    if (state.failure == null) return;
    emit(state.copyWith(clearError: true));
  }

  void clearResendFeedback() {
    if (state.resendMessage == null && state.resendFailure == null) return;
    emit(state.copyWith(clearResend: true));
  }

  Future<void> _verify(VerifyResetOtpRequestEntity request) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _verifyResetOtpUseCase.call(request);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            response: result.data,
            clearError: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            failure: result.failure,
          ),
        );
    }
  }

  Future<void> _resendCode(String identifier) async {
    emit(state.copyWith(isResending: true, clearResend: true));

    final result = await _resendDriverOtpUseCase.call(
      ResendDriverOtpRequestEntity(identifier: identifier),
    );

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isResending: false,
            resendMessage: result.data.message,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isResending: false,
            resendFailure: result.failure,
          ),
        );
    }
  }
}
