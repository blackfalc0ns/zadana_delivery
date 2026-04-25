import '../../domain/entities/register_request_entity.dart';

sealed class RegisterEvent {
  const RegisterEvent();
}

class RegisterSubmitEvent extends RegisterEvent {
  const RegisterSubmitEvent(this.request);

  final RegisterRequestEntity request;
}
