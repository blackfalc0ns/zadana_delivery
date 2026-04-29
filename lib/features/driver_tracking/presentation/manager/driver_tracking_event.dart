import 'package:zadana_delivery/features/driver_home/domain/entities/driver_home_entity.dart';

sealed class DriverTrackingEvent {
  const DriverTrackingEvent();
}

class DriverTrackingBootstrapEvent extends DriverTrackingEvent {
  const DriverTrackingBootstrapEvent();
}

class DriverTrackingAssignmentChangedEvent extends DriverTrackingEvent {
  const DriverTrackingAssignmentChangedEvent(this.assignment);

  final DriverHomeAssignmentEntity? assignment;
}

class DriverTrackingStartRequestedEvent extends DriverTrackingEvent {
  const DriverTrackingStartRequestedEvent();
}

class DriverTrackingStopRequestedEvent extends DriverTrackingEvent {
  const DriverTrackingStopRequestedEvent();
}

class DriverTrackingLocationReceivedEvent extends DriverTrackingEvent {
  const DriverTrackingLocationReceivedEvent();
}

class DriverTrackingLocationFailedEvent extends DriverTrackingEvent {
  const DriverTrackingLocationFailedEvent(this.message);

  final String message;
}

class DriverTrackingPermissionSyncEvent extends DriverTrackingEvent {
  const DriverTrackingPermissionSyncEvent();
}
