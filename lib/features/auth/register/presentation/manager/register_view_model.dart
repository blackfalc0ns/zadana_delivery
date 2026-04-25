import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../../domain/entities/register_request_entity.dart';
import '../../domain/usecase/register_usecase.dart';
import '../models/register_profile_draft.dart';
import 'register_event.dart';
import 'register_state.dart';

@injectable
class RegisterViewModel extends Cubit<RegisterState> {
  RegisterViewModel(this._registerUseCase) : super(const RegisterState());

  final RegisterUseCase _registerUseCase;

  Future<void> doIntent(RegisterEvent event) async {
    switch (event) {
      case RegisterSubmitEvent():
        await _submit(event.request);
    }
  }

  void clearError() {
    if (state.errorMessage == null && state.failure == null) return;
    emit(state.copyWith(clearError: true));
  }

  void seedDraft(RegisterProfileDraft draft) {
    emit(state.copyWith(draft: draft));
  }

  void updateDraft(RegisterProfileDraft draft) {
    emit(state.copyWith(draft: draft));
  }

  Future<void> _submit(RegisterRequestEntity request) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _registerUseCase.call(request);

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
