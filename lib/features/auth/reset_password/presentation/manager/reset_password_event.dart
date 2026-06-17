import '../../domain/entities/reset_password_request_entity.dart';

sealed class ResetPasswordEvent {
  const ResetPasswordEvent();
}

class ResetPasswordSubmitEvent extends ResetPasswordEvent {
  const ResetPasswordSubmitEvent(this.request);

  final ResetPasswordRequestEntity request;
}

class ResetPasswordResendCodeEvent extends ResetPasswordEvent {
  const ResetPasswordResendCodeEvent(this.identifier);

  final String identifier;
}
