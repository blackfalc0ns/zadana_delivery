sealed class AuthGateEvent {
  const AuthGateEvent();
}

class AuthGateStartedEvent extends AuthGateEvent {
  const AuthGateStartedEvent();
}

class AuthGateLogoutRequestedEvent extends AuthGateEvent {
  const AuthGateLogoutRequestedEvent();
}

class AuthGateFeedbackHandledEvent extends AuthGateEvent {
  const AuthGateFeedbackHandledEvent();
}
