import 'package:zadana_delivery/core/network/failures.dart';

import '../../domain/entities/verify_reset_otp_response_entity.dart';

class VerifyResetOtpState {
  const VerifyResetOtpState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isResending = false,
    this.response,
    this.failure,
    this.resendMessage,
    this.resendFailure,
  });

  final bool isLoading;
  final bool isSuccess;
  final bool isResending;
  final VerifyResetOtpResponseEntity? response;
  final Failure? failure;
  final String? resendMessage;
  final Failure? resendFailure;

  VerifyResetOtpState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isResending,
    VerifyResetOtpResponseEntity? response,
    Failure? failure,
    bool clearError = false,
    String? resendMessage,
    Failure? resendFailure,
    bool clearResend = false,
  }) {
    return VerifyResetOtpState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isResending: isResending ?? this.isResending,
      response: response ?? this.response,
      failure: clearError ? null : failure ?? this.failure,
      resendMessage: clearResend ? null : resendMessage ?? this.resendMessage,
      resendFailure: clearResend ? null : resendFailure ?? this.resendFailure,
    );
  }
}
