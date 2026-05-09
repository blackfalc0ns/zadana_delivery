import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_message_request_entity.dart';

sealed class OrderDetailsEvent {
  const OrderDetailsEvent();
}

class OrderDetailsLoadAssignmentEvent extends OrderDetailsEvent {
  const OrderDetailsLoadAssignmentEvent(
    this.assignmentId, {
    this.silent = false,
  });

  final String assignmentId;
  final bool silent;
}

class OrderDetailsClearErrorEvent extends OrderDetailsEvent {
  const OrderDetailsClearErrorEvent();
}

class OrderDetailsActivateRealtimeEvent extends OrderDetailsEvent {
  const OrderDetailsActivateRealtimeEvent({
    required this.assignmentId,
    required this.orderId,
  });

  final String assignmentId;
  final String orderId;
}

class OrderDetailsDeactivateRealtimeEvent extends OrderDetailsEvent {
  const OrderDetailsDeactivateRealtimeEvent();
}

class OrderDetailsConsumeNotificationEvent extends OrderDetailsEvent {
  const OrderDetailsConsumeNotificationEvent();
}

class OrderDetailsAcceptOfferEvent extends OrderDetailsEvent {
  const OrderDetailsAcceptOfferEvent(this.assignmentId);

  final String assignmentId;
}

class OrderDetailsRejectOfferEvent extends OrderDetailsEvent {
  const OrderDetailsRejectOfferEvent(this.assignmentId, {this.reason});

  final String assignmentId;
  final String? reason;
}

class OrderDetailsMarkPickedUpEvent extends OrderDetailsEvent {
  const OrderDetailsMarkPickedUpEvent(this.orderId);

  final String orderId;
}

class OrderDetailsMarkOnTheWayEvent extends OrderDetailsEvent {
  const OrderDetailsMarkOnTheWayEvent(this.orderId);

  final String orderId;
}

class OrderDetailsMarkDeliveredEvent extends OrderDetailsEvent {
  const OrderDetailsMarkDeliveredEvent(this.orderId, {this.request});

  final String orderId;
  final Map<String, dynamic>? request;
}

class OrderDetailsMarkDeliveryFailedEvent extends OrderDetailsEvent {
  const OrderDetailsMarkDeliveryFailedEvent(this.orderId, {this.request});

  final String orderId;
  final Map<String, dynamic>? request;
}

class OrderDetailsUpdateArrivalStateEvent extends OrderDetailsEvent {
  const OrderDetailsUpdateArrivalStateEvent(
    this.orderId, {
    required this.arrivalState,
  });

  final String orderId;
  final String arrivalState;
}

class OrderDetailsVerifyDeliveryOtpEvent extends OrderDetailsEvent {
  const OrderDetailsVerifyDeliveryOtpEvent(
    this.assignmentId, {
    required this.otpCode,
  });

  final String assignmentId;
  final String otpCode;
}

// class OrderDetailsVerifyPickupOtpEvent extends OrderDetailsEvent {
//   const OrderDetailsVerifyPickupOtpEvent(
//     this.assignmentId, {
//     required this.otpCode,
//   });

//   final String assignmentId;
//   final String otpCode;
// }
class OrderDetailsVerifyPickupOtpEvent extends OrderDetailsEvent {
  const OrderDetailsVerifyPickupOtpEvent(
    this.assignmentId, {
    required this.otpCode,
  });

  final String assignmentId;
  final String otpCode;
}

class OrderDetailsResendDeliveryOtpEvent extends OrderDetailsEvent {
  const OrderDetailsResendDeliveryOtpEvent(this.assignmentId);

  final String assignmentId;
}

class OrderDetailsResendPickupOtpEvent extends OrderDetailsEvent {
  const OrderDetailsResendPickupOtpEvent(this.assignmentId);

  final String assignmentId;
}

class OrderDetailsReportIssueEvent extends OrderDetailsEvent {
  const OrderDetailsReportIssueEvent(this.orderId, {required this.request});

  final String orderId;
  final DriverSupportCaseMessageRequestEntity request;
}

class OrderDetailsCreateDisputeEvent extends OrderDetailsEvent {
  const OrderDetailsCreateDisputeEvent(this.orderId, {required this.request});

  final String orderId;
  final DriverSupportCaseMessageRequestEntity request;
}
