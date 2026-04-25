import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../../domain/entities/reset_password_request_entity.dart';
import '../../domain/usecase/reset_password_usecase.dart';
import 'reset_password_event.dart';
import 'reset_password_state.dart';

@injectable
class ResetPasswordViewModel extends Cubit<ResetPasswordState> {
  ResetPasswordViewModel(this._useCase) : super(const ResetPasswordState());

  final ResetPasswordUseCase _useCase;

  Future<void> doIntent(ResetPasswordEvent event) async {
    switch (event) {
      case ResetPasswordSubmitEvent():
        await _submit(event.request);
    }
  }

  void clearError() {
    if (state.errorMessage == null && state.failure == null) return;
    emit(state.copyWith(clearError: true));
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
            errorMessage: result.failure.errorMessage,
            failure: result.failure,
          ),
        );
    }
  }
}
