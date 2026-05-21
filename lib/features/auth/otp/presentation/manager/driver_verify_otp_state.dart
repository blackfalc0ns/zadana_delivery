import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/auth/login/domain/entities/login_response_entity.dart';

class DriverVerifyOtpState {
  const DriverVerifyOtpState({
    this.isLoading = false,
    this.isResending = false,
    this.isSuccess = false,
    this.response,
    this.failure,
    this.resendFailure,
    this.resendMessage,
  });

  final bool isLoading;
  final bool isResending;
  final bool isSuccess;
  final LoginResponseEntity? response;
  final Failure? failure;
  final Failure? resendFailure;
  final String? resendMessage;

  DriverVerifyOtpState copyWith({
    bool? isLoading,
    bool? isResending,
    bool? isSuccess,
    LoginResponseEntity? response,
    Failure? failure,
    Failure? resendFailure,
    String? resendMessage,
    bool clearError = false,
    bool clearResendFeedback = false,
  }) {
    return DriverVerifyOtpState(
      isLoading: isLoading ?? this.isLoading,
      isResending: isResending ?? this.isResending,
      isSuccess: isSuccess ?? this.isSuccess,
      response: response ?? this.response,
      failure: clearError ? null : failure ?? this.failure,
      resendFailure: clearResendFeedback
          ? null
          : resendFailure ?? this.resendFailure,
      resendMessage: clearResendFeedback
          ? null
          : resendMessage ?? this.resendMessage,
    );
  }
}
