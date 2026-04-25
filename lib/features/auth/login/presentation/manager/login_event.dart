import '../../domain/entities/login_request_entity.dart';

sealed class LoginEvent {
  const LoginEvent();
}

class LoginSubmitEvent extends LoginEvent {
  const LoginSubmitEvent(this.request);

  final LoginRequestEntity request;
}
