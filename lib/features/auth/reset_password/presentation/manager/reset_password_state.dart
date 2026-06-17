import 'package:zadana_delivery/core/network/failures.dart';

import '../../domain/entities/reset_password_response_entity.dart';

class ResetPasswordState {
  const ResetPasswordState({
    this.isLoading = false,
    this.isSuccess = false,
    this.response,
    this.failure,
    this.isResending = false,
    this.resendMessage,
    this.resendFailure,
  });

  final bool isLoading;
  final bool isSuccess;
  final ResetPasswordResponseEntity? response;
  final Failure? failure;
  final bool isResending;
  final String? resendMessage;
  final Failure? resendFailure;

  ResetPasswordState copyWith({
    bool? isLoading,
    bool? isSuccess,
    ResetPasswordResponseEntity? response,
    Failure? failure,
    bool clearError = false,
    bool? isResending,
    String? resendMessage,
    Failure? resendFailure,
    bool clearResend = false,
  }) {
    return ResetPasswordState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      response: response ?? this.response,
      failure: clearError ? null : failure ?? this.failure,
      isResending: isResending ?? this.isResending,
      resendMessage: clearResend ? null : resendMessage ?? this.resendMessage,
      resendFailure: clearResend ? null : resendFailure ?? this.resendFailure,
    );
  }
}
