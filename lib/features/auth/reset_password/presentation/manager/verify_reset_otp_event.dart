import '../../domain/entities/verify_reset_otp_request_entity.dart';

sealed class VerifyResetOtpEvent {
  const VerifyResetOtpEvent();
}

class VerifyResetOtpSubmitEvent extends VerifyResetOtpEvent {
  const VerifyResetOtpSubmitEvent(this.request);

  final VerifyResetOtpRequestEntity request;
}

class VerifyResetOtpResendEvent extends VerifyResetOtpEvent {
  const VerifyResetOtpResendEvent(this.identifier);

  final String identifier;
}
