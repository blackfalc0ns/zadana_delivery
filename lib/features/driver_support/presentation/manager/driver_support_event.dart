import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_message_request_entity.dart';

sealed class DriverSupportEvent {
  const DriverSupportEvent();
}

class DriverSupportLoadCasesEvent extends DriverSupportEvent {
  const DriverSupportLoadCasesEvent({this.refresh = false});

  final bool refresh;
}

class DriverSupportLoadCaseDetailsEvent extends DriverSupportEvent {
  const DriverSupportLoadCaseDetailsEvent(this.caseId, {this.refresh = false});

  final String caseId;
  final bool refresh;
}

class DriverSupportSendMessageEvent extends DriverSupportEvent {
  const DriverSupportSendMessageEvent({
    required this.orderId,
    required this.caseId,
    required this.request,
  });

  final String orderId;
  final String caseId;
  final DriverSupportCaseMessageRequestEntity request;
}

class DriverSupportClearErrorEvent extends DriverSupportEvent {
  const DriverSupportClearErrorEvent();
}

class DriverSupportConsumeSuccessEvent extends DriverSupportEvent {
  const DriverSupportConsumeSuccessEvent();
}
