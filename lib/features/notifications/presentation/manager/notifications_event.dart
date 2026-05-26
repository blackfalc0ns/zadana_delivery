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

class NotificationsDeleteEvent extends NotificationsEvent {
  const NotificationsDeleteEvent(this.id);

  final String id;
}

class NotificationsDeleteAllEvent extends NotificationsEvent {
  const NotificationsDeleteAllEvent();
}

class NotificationsLoadPreferencesEvent extends NotificationsEvent {
  const NotificationsLoadPreferencesEvent();
}

class NotificationsUpdatePreferencesEvent extends NotificationsEvent {
  const NotificationsUpdatePreferencesEvent(this.body);

  final Map<String, dynamic> body;
}
