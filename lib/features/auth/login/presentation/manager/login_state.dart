import 'package:zadana_delivery/core/network/failures.dart';

import '../../domain/entities/login_response_entity.dart';

class LoginState {
  const LoginState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.response,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final LoginResponseEntity? response;
  final Failure? failure;

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    LoginResponseEntity? response,
    Failure? failure,
    bool clearError = false,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      response: response ?? this.response,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}
