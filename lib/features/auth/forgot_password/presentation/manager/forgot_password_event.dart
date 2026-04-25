import '../../domain/entities/forgot_password_request_entity.dart';

sealed class ForgotPasswordEvent {
  const ForgotPasswordEvent();
}

class ForgotPasswordSubmitEvent extends ForgotPasswordEvent {
  const ForgotPasswordSubmitEvent(this.request);

  final ForgotPasswordRequestEntity request;
}
