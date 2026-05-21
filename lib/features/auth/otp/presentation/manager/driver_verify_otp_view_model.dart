import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/auth/otp/domain/entities/resend_driver_otp_request_entity.dart';
import 'package:zadana_delivery/features/auth/otp/domain/entities/verify_driver_otp_request_entity.dart';

import '../../domain/usecase/resend_driver_otp_usecase.dart';
import '../../domain/usecase/verify_driver_otp_usecase.dart';
import 'driver_verify_otp_event.dart';
import 'driver_verify_otp_state.dart';

@injectable
class DriverVerifyOtpViewModel extends Cubit<DriverVerifyOtpState> {
  DriverVerifyOtpViewModel(
    this._verifyDriverOtpUseCase,
    this._resendDriverOtpUseCase,
  ) : super(const DriverVerifyOtpState());

  final VerifyDriverOtpUseCase _verifyDriverOtpUseCase;
  final ResendDriverOtpUseCase _resendDriverOtpUseCase;

  Future<void> doIntent(DriverVerifyOtpEvent event) async {
    switch (event) {
      case DriverVerifyOtpSubmitEvent():
        await _submit(event.request);
      case DriverVerifyOtpResendEvent():
        await _resend(event.request);
    }
  }

  void clearError() {
    if (state.failure == null) return;
    emit(state.copyWith(clearError: true));
  }

  void clearResendFeedback() {
    if (state.resendFailure == null && state.resendMessage == null) return;
    emit(state.copyWith(clearResendFeedback: true));
  }

  Future<void> _submit(VerifyDriverOtpRequestEntity request) async {
    emit(
      state.copyWith(
        isLoading: true,
        isSuccess: false,
        clearError: true,
        clearResendFeedback: true,
      ),
    );

    final result = await _verifyDriverOtpUseCase.call(request);

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

  Future<void> _resend(ResendDriverOtpRequestEntity request) async {
    emit(state.copyWith(isResending: true, clearResendFeedback: true));

    final result = await _resendDriverOtpUseCase.call(request);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isResending: false,
            resendMessage: result.data.message,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isResending: false, resendFailure: result.failure));
    }
  }
}
