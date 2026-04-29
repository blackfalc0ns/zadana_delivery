sealed class DriverHomeEvent {
  const DriverHomeEvent();
}

class DriverHomeInitializeEvent extends DriverHomeEvent {
  const DriverHomeInitializeEvent();
}

class DriverHomeLoadEvent extends DriverHomeEvent {
  const DriverHomeLoadEvent({this.refresh = false});

  final bool refresh;
}

class DriverHomeClearErrorEvent extends DriverHomeEvent {
  const DriverHomeClearErrorEvent();
}

class DriverHomeToggleAvailabilityEvent extends DriverHomeEvent {
  const DriverHomeToggleAvailabilityEvent(this.isAvailable);

  final bool isAvailable;
}

class DriverHomeAcceptOfferEvent extends DriverHomeEvent {
  const DriverHomeAcceptOfferEvent(this.assignmentId);

  final String assignmentId;
}

class DriverHomeRejectOfferEvent extends DriverHomeEvent {
  const DriverHomeRejectOfferEvent(this.assignmentId, {this.reason});

  final String assignmentId;
  final String? reason;
}
