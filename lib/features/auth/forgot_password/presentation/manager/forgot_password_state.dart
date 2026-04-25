import 'package:zadana_delivery/core/network/failures.dart';

import '../../domain/entities/forgot_password_response_entity.dart';

class ForgotPasswordState {
  const ForgotPasswordState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.response,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final ForgotPasswordResponseEntity? response;
  final Failure? failure;

  ForgotPasswordState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    ForgotPasswordResponseEntity? response,
    Failure? failure,
    bool clearError = false,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      response: response ?? this.response,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}
