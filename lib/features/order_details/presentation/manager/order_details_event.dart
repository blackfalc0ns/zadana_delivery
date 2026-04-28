sealed class OrderDetailsEvent {
  const OrderDetailsEvent();
}

class OrderDetailsLoadAssignmentEvent extends OrderDetailsEvent {
  const OrderDetailsLoadAssignmentEvent(this.assignmentId);

  final String assignmentId;
}

class OrderDetailsClearErrorEvent extends OrderDetailsEvent {
  const OrderDetailsClearErrorEvent();
}
