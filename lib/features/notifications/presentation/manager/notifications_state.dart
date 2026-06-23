import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/notifications/domain/entities/driver_notifications_page_entity.dart';

class NotificationsState {
  const NotificationsState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.isMarkingAllRead = false,
    this.isDeletingAll = false,
    this.isNotificationActionLoading = false,
    this.hasLoadedOnce = false,
    this.activeNotificationId,
    this.notifications,
    this.unreadCount = 0,
    this.failure,
    this.preferences,
    this.isPreferencesLoading = false,
  });

  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool isMarkingAllRead;
  final bool isDeletingAll;
  final bool isNotificationActionLoading;
  final bool hasLoadedOnce;
  final String? activeNotificationId;
  final DriverNotificationsPageEntity? notifications;
  final int unreadCount;
  final Failure? failure;
  final Map<String, dynamic>? preferences;
  final bool isPreferencesLoading;

  NotificationsState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? isMarkingAllRead,
    bool? isDeletingAll,
    bool? isNotificationActionLoading,
    bool? hasLoadedOnce,
    String? activeNotificationId,
    DriverNotificationsPageEntity? notifications,
    int? unreadCount,
    Failure? failure,
    Map<String, dynamic>? preferences,
    bool? isPreferencesLoading,
    bool clearFailure = false,
    bool clearActiveNotificationId = false,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isMarkingAllRead: isMarkingAllRead ?? this.isMarkingAllRead,
      isDeletingAll: isDeletingAll ?? this.isDeletingAll,
      isNotificationActionLoading:
          isNotificationActionLoading ?? this.isNotificationActionLoading,
      hasLoadedOnce: hasLoadedOnce ?? this.hasLoadedOnce,
      activeNotificationId: clearActiveNotificationId
          ? null
          : activeNotificationId ?? this.activeNotificationId,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      failure: clearFailure ? null : failure ?? this.failure,
      preferences: preferences ?? this.preferences,
      isPreferencesLoading: isPreferencesLoading ?? this.isPreferencesLoading,
    );
  }
}
