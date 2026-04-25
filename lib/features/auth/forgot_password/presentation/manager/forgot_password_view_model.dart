import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../../domain/entities/forgot_password_request_entity.dart';
import '../../domain/usecase/forgot_password_usecase.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

@injectable
class ForgotPasswordViewModel extends Cubit<ForgotPasswordState> {
  ForgotPasswordViewModel(this._useCase) : super(const ForgotPasswordState());

  final ForgotPasswordUseCase _useCase;

  Future<void> doIntent(ForgotPasswordEvent event) async {
    switch (event) {
      case ForgotPasswordSubmitEvent():
        await _submit(event.request);
    }
  }

  void clearError() {
    if (state.failure == null) return;
    emit(state.copyWith(clearError: true));
  }

  Future<void> _submit(ForgotPasswordRequestEntity request) async {
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
}
