sealed class NotificationsEvent {
  const NotificationsEvent();
}

class NotificationsLoadEvent extends NotificationsEvent {
  const NotificationsLoadEvent({this.refresh = false});

  final bool refresh;
}

class NotificationsClearErrorEvent extends NotificationsEvent {
  const NotificationsClearErrorEvent();
}

class NotificationsMarkReadEvent extends NotificationsEvent {
  const NotificationsMarkReadEvent(this.id);

  final String id;
}

class NotificationsMarkAllReadEvent extends NotificationsEvent {
  const NotificationsMarkAllReadEvent();
}

class NotificationsRefreshUnreadCountEvent extends NotificationsEvent {
  const NotificationsRefreshUnreadCountEvent();
}
