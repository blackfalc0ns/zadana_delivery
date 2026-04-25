import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';

import '../../domain/entities/login_request_entity.dart';
import '../../domain/usecase/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

@injectable
class LoginViewModel extends Cubit<LoginState> {
  LoginViewModel(this._loginUseCase) : super(const LoginState());

  final LoginUseCase _loginUseCase;

  Future<void> doIntent(LoginEvent event) async {
    switch (event) {
      case LoginSubmitEvent():
        await _login(event.request);
    }
  }

  void clearError() {
    if (state.failure == null) return;
    emit(state.copyWith(clearError: true));
  }

  Future<void> _login(LoginRequestEntity request) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final result = await _loginUseCase.call(request);

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
