import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/auth/forgot_password/domain/entities/forgot_password_request_entity.dart';
import 'package:zadana_delivery/features/auth/forgot_password/domain/usecase/forgot_password_usecase.dart';

import '../../domain/entities/reset_password_request_entity.dart';
import '../../domain/usecase/reset_password_usecase.dart';
import 'reset_password_event.dart';
import 'reset_password_state.dart';

@injectable
class ResetPasswordViewModel extends Cubit<ResetPasswordState> {
  ResetPasswordViewModel(this._useCase, this._forgotPasswordUseCase)
      : super(const ResetPasswordState());

  final ResetPasswordUseCase _useCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  Future<void> doIntent(ResetPasswordEvent event) async {
    switch (event) {
      case ResetPasswordSubmitEvent():
        await _submit(event.request);
      case ResetPasswordResendCodeEvent():
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

  Future<void> _submit(ResetPasswordRequestEntity request) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _useCase.call(request);

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

    final result = await _forgotPasswordUseCase.call(
      ForgotPasswordRequestEntity(identifier: identifier),
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
