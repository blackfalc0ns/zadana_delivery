import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/notifications/domain/entities/driver_notifications_page_entity.dart';

class NotificationsState {
  const NotificationsState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.isMarkingAllRead = false,
    this.isNotificationActionLoading = false,
    this.hasLoadedOnce = false,
    this.activeNotificationId,
    this.notifications,
    this.unreadCount = 0,
    this.failure,
  });

  final bool isLoading;
  final bool isRefreshing;
  final bool isMarkingAllRead;
  final bool isNotificationActionLoading;
  final bool hasLoadedOnce;
  final String? activeNotificationId;
  final DriverNotificationsPageEntity? notifications;
  final int unreadCount;
  final Failure? failure;

  NotificationsState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isMarkingAllRead,
    bool? isNotificationActionLoading,
    bool? hasLoadedOnce,
    String? activeNotificationId,
    DriverNotificationsPageEntity? notifications,
    int? unreadCount,
    Failure? failure,
    bool clearFailure = false,
    bool clearActiveNotificationId = false,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isMarkingAllRead: isMarkingAllRead ?? this.isMarkingAllRead,
      isNotificationActionLoading:
          isNotificationActionLoading ?? this.isNotificationActionLoading,
      hasLoadedOnce: hasLoadedOnce ?? this.hasLoadedOnce,
      activeNotificationId: clearActiveNotificationId
          ? null
          : activeNotificationId ?? this.activeNotificationId,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}
