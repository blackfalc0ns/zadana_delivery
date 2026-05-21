import '../../domain/entities/resend_driver_otp_request_entity.dart';
import '../../domain/entities/verify_driver_otp_request_entity.dart';

sealed class DriverVerifyOtpEvent {
  const DriverVerifyOtpEvent();
}

class DriverVerifyOtpSubmitEvent extends DriverVerifyOtpEvent {
  const DriverVerifyOtpSubmitEvent(this.request);

  final VerifyDriverOtpRequestEntity request;
}

class DriverVerifyOtpResendEvent extends DriverVerifyOtpEvent {
  const DriverVerifyOtpResendEvent(this.request);

  final ResendDriverOtpRequestEntity request;
}
