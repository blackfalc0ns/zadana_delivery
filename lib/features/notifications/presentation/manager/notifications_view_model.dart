import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/services/driver_realtime_service.dart';
import 'package:zadana_delivery/features/notifications/domain/entities/driver_notification_entity.dart';
import 'package:zadana_delivery/features/notifications/domain/usecase/delete_all_driver_notifications_usecase.dart';
import 'package:zadana_delivery/features/notifications/domain/usecase/delete_driver_notification_usecase.dart';
import 'package:zadana_delivery/features/notifications/domain/usecase/get_driver_notifications_unread_count_usecase.dart';
import 'package:zadana_delivery/features/notifications/domain/usecase/get_driver_notifications_usecase.dart';
import 'package:zadana_delivery/features/notifications/domain/usecase/get_notification_preferences_usecase.dart';
import 'package:zadana_delivery/features/notifications/domain/usecase/mark_all_driver_notifications_read_usecase.dart';
import 'package:zadana_delivery/features/notifications/domain/usecase/mark_driver_notification_read_usecase.dart';
import 'package:zadana_delivery/features/notifications/domain/usecase/update_notification_preferences_usecase.dart';
import 'package:zadana_delivery/features/notifications/presentation/manager/notifications_event.dart';
import 'package:zadana_delivery/features/notifications/presentation/manager/notifications_state.dart';

@injectable
class NotificationsViewModel extends Cubit<NotificationsState> {
  NotificationsViewModel(
    this._getDriverNotificationsUseCase,
    this._markDriverNotificationReadUseCase,
    this._markAllDriverNotificationsReadUseCase,
    this._getDriverNotificationsUnreadCountUseCase,
    this._deleteDriverNotificationUseCase,
    this._deleteAllDriverNotificationsUseCase,
    this._getNotificationPreferencesUseCase,
    this._updateNotificationPreferencesUseCase,
  ) : super(const NotificationsState()) {
    _notificationSubscription = getIt<DriverRealtimeService>().notifications
        .listen((_) {
          _handleRealtimeNotificationRefresh();
        });
    _supportCaseChangedSubscription =
        getIt<DriverRealtimeService>().supportCaseChanged.listen((_) {
          _handleRealtimeNotificationRefresh();
        });
  }

  final GetDriverNotificationsUseCase _getDriverNotificationsUseCase;
  final MarkDriverNotificationReadUseCase _markDriverNotificationReadUseCase;
  final MarkAllDriverNotificationsReadUseCase
  _markAllDriverNotificationsReadUseCase;
  final GetDriverNotificationsUnreadCountUseCase
  _getDriverNotificationsUnreadCountUseCase;
  final DeleteDriverNotificationUseCase _deleteDriverNotificationUseCase;
  final DeleteAllDriverNotificationsUseCase
  _deleteAllDriverNotificationsUseCase;
  final GetNotificationPreferencesUseCase _getNotificationPreferencesUseCase;
  final UpdateNotificationPreferencesUseCase
  _updateNotificationPreferencesUseCase;
  late final StreamSubscription<Map<String, dynamic>> _notificationSubscription;
  late final StreamSubscription<Map<String, dynamic>>
  _supportCaseChangedSubscription;

  List<DriverNotificationEntity> get items =>
      state.notifications?.items ?? const <DriverNotificationEntity>[];

  bool get showGlobalError =>
      !state.isLoading &&
      !state.isRefreshing &&
      state.failure != null &&
      items.isEmpty;

  void loadInitial() {
    doIntent(const NotificationsLoadEvent());
  }

  Future<void> refreshNotifications() async {
    await doIntent(const NotificationsLoadEvent(refresh: true));
  }

  Future<void> loadMore() async {
    await doIntent(const NotificationsLoadMoreEvent());
  }

  Future<bool> markAsRead(String id) {
    return doIntent(NotificationsMarkReadEvent(id));
  }

  Future<bool> markAllAsRead() {
    return doIntent(const NotificationsMarkAllReadEvent());
  }

  void clearError() {
    doIntent(const NotificationsClearErrorEvent());
  }

  bool isNotificationLoading(String id) {
    return state.isNotificationActionLoading &&
        state.activeNotificationId == id;
  }

  Future<bool> doIntent(NotificationsEvent event) async {
    switch (event) {
      case NotificationsLoadEvent():
        return _loadNotifications(refresh: event.refresh);
      case NotificationsLoadMoreEvent():
        return _loadMoreNotifications();
      case NotificationsClearErrorEvent():
        _clearError();
        return true;
      case NotificationsMarkReadEvent():
        return _markAsRead(event.id);
      case NotificationsMarkAllReadEvent():
        return _markAllAsRead();
      case NotificationsRefreshUnreadCountEvent():
        return _refreshUnreadCount();
      case NotificationsDeleteEvent():
        return _deleteNotification(event.id);
      case NotificationsDeleteAllEvent():
        return _deleteAllNotifications();
      case NotificationsLoadPreferencesEvent():
        return _loadPreferences();
      case NotificationsUpdatePreferencesEvent():
        return _updatePreferences(event.body);
    }
  }

  Future<bool> _loadNotifications({bool refresh = false}) async {
    emit(
      state.copyWith(
        isLoading: !refresh,
        isRefreshing: refresh,
        clearFailure: true,
      ),
    );

    final result = await _getDriverNotificationsUseCase.call();
    switch (result) {
      case ApiSuccessResult(data: final notifications):
        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            hasLoadedOnce: true,
            notifications: notifications,
            unreadCount: notifications.unreadCount,
            clearFailure: true,
          ),
        );
        return true;
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            failure: result.failure,
          ),
        );
        return false;
    }
  }

  Future<bool> _loadMoreNotifications() async {
    final currentNotifications = state.notifications;
    if (currentNotifications == null) return false;
    if (state.isLoadingMore || !currentNotifications.hasMore) return false;

    emit(state.copyWith(isLoadingMore: true, clearFailure: true));

    final nextPage = currentNotifications.page + 1;
    final result = await _getDriverNotificationsUseCase.call(
      page: nextPage,
      perPage: currentNotifications.perPage,
    );

    switch (result) {
      case ApiSuccessResult(data: final page):
        final allItems = [...currentNotifications.items, ...page.items];
        emit(
          state.copyWith(
            isLoadingMore: false,
            notifications: currentNotifications.copyWith(
              items: allItems,
              page: page.page,
              hasMore: page.hasMore,
              total: page.total,
              unreadCount: page.unreadCount,
            ),
            unreadCount: page.unreadCount,
            clearFailure: true,
          ),
        );
        return true;
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoadingMore: false,
            failure: result.failure,
          ),
        );
        return false;
    }
  }

  Future<bool> _markAsRead(String id) async {
    final currentNotifications = state.notifications;
    if (currentNotifications == null) return false;

    final currentItem = _findNotificationById(id);
    if (currentItem == null || currentItem.isRead) return true;

    emit(
      state.copyWith(
        isNotificationActionLoading: true,
        activeNotificationId: id,
        clearFailure: true,
      ),
    );

    final result = await _markDriverNotificationReadUseCase.call(id);
    switch (result) {
      case ApiSuccessResult():
        final updatedItems = currentNotifications.items
            .map((item) => item.id == id ? item.copyWith(isRead: true) : item)
            .toList(growable: false);
        final fallbackUnreadCount = _countUnread(updatedItems);
        final syncedUnreadCount = await _syncUnreadCount(fallbackUnreadCount);

        emit(
          state.copyWith(
            isNotificationActionLoading: false,
            clearActiveNotificationId: true,
            notifications: currentNotifications.copyWith(
              items: updatedItems,
              unreadCount: syncedUnreadCount,
            ),
            unreadCount: syncedUnreadCount,
            clearFailure: true,
          ),
        );
        return true;
      case ApiErrorResult():
        emit(
          state.copyWith(
            isNotificationActionLoading: false,
            clearActiveNotificationId: true,
            failure: result.failure,
          ),
        );
        return false;
    }
  }

  Future<bool> _markAllAsRead() async {
    final currentNotifications = state.notifications;
    if (currentNotifications == null) return false;
    if (_countUnread(currentNotifications.items) == 0) return true;

    emit(state.copyWith(isMarkingAllRead: true, clearFailure: true));

    final result = await _markAllDriverNotificationsReadUseCase.call();
    switch (result) {
      case ApiSuccessResult():
        final updatedItems = currentNotifications.items
            .map((item) => item.isRead ? item : item.copyWith(isRead: true))
            .toList(growable: false);
        final syncedUnreadCount = await _syncUnreadCount(0);

        emit(
          state.copyWith(
            isMarkingAllRead: false,
            notifications: currentNotifications.copyWith(
              items: updatedItems,
              unreadCount: syncedUnreadCount,
            ),
            unreadCount: syncedUnreadCount,
            clearFailure: true,
          ),
        );
        return true;
      case ApiErrorResult():
        emit(state.copyWith(isMarkingAllRead: false, failure: result.failure));
        return false;
    }
  }

  Future<bool> _refreshUnreadCount() async {
    final syncedUnreadCount = await _syncUnreadCount(state.unreadCount);
    final currentNotifications = state.notifications;
    emit(
      state.copyWith(
        unreadCount: syncedUnreadCount,
        notifications: currentNotifications?.copyWith(
          unreadCount: syncedUnreadCount,
        ),
      ),
    );
    return true;
  }

  Future<int> _syncUnreadCount(int fallbackCount) async {
    final result = await _getDriverNotificationsUnreadCountUseCase.call();
    switch (result) {
      case ApiSuccessResult(data: final unreadCount):
        return unreadCount.count;
      case ApiErrorResult():
        return fallbackCount;
    }
  }

  DriverNotificationEntity? _findNotificationById(String id) {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  int _countUnread(List<DriverNotificationEntity> items) {
    return items.where((item) => !item.isRead).length;
  }

  Future<bool> deleteNotification(String id) {
    return doIntent(NotificationsDeleteEvent(id));
  }

  Future<bool> deleteAllNotifications() {
    return doIntent(const NotificationsDeleteAllEvent());
  }

  Future<bool> loadPreferences() {
    return doIntent(const NotificationsLoadPreferencesEvent());
  }

  Future<bool> updatePreferences(Map<String, dynamic> body) {
    return doIntent(NotificationsUpdatePreferencesEvent(body));
  }

  void _handleRealtimeNotificationRefresh() {
    unawaited(_refreshUnreadCount());
    if (state.hasLoadedOnce && !state.isLoading) {
      unawaited(_loadNotifications(refresh: true));
    }
  }

  void _clearError() {
    if (state.failure == null) return;
    emit(state.copyWith(clearFailure: true));
  }

  Future<bool> _deleteNotification(String id) async {
    final currentNotifications = state.notifications;
    if (currentNotifications == null) return false;

    emit(
      state.copyWith(
        isNotificationActionLoading: true,
        activeNotificationId: id,
        clearFailure: true,
      ),
    );

    final result = await _deleteDriverNotificationUseCase.call(id);
    switch (result) {
      case ApiSuccessResult():
        final updatedItems = currentNotifications.items
            .where((item) => item.id != id)
            .toList(growable: false);
        final syncedUnreadCount = await _syncUnreadCount(
          _countUnread(updatedItems),
        );

        emit(
          state.copyWith(
            isNotificationActionLoading: false,
            clearActiveNotificationId: true,
            notifications: currentNotifications.copyWith(
              items: updatedItems,
              unreadCount: syncedUnreadCount,
            ),
            unreadCount: syncedUnreadCount,
            clearFailure: true,
          ),
        );
        return true;
      case ApiErrorResult():
        emit(
          state.copyWith(
            isNotificationActionLoading: false,
            clearActiveNotificationId: true,
            failure: result.failure,
          ),
        );
        return false;
    }
  }

  Future<bool> _deleteAllNotifications() async {
    emit(state.copyWith(isDeletingAll: true, clearFailure: true));

    final result = await _deleteAllDriverNotificationsUseCase.call();
    switch (result) {
      case ApiSuccessResult():
        final currentNotifications = state.notifications;
        emit(
          state.copyWith(
            isDeletingAll: false,
            notifications: currentNotifications?.copyWith(
              items: const <DriverNotificationEntity>[],
              unreadCount: 0,
            ),
            unreadCount: 0,
            clearFailure: true,
          ),
        );
        return true;
      case ApiErrorResult():
        emit(state.copyWith(isDeletingAll: false, failure: result.failure));
        return false;
    }
  }

  Future<bool> _loadPreferences() async {
    emit(state.copyWith(isPreferencesLoading: true, clearFailure: true));

    final result = await _getNotificationPreferencesUseCase.call();
    switch (result) {
      case ApiSuccessResult(data: final prefs):
        emit(
          state.copyWith(
            isPreferencesLoading: false,
            preferences: prefs,
            clearFailure: true,
          ),
        );
        return true;
      case ApiErrorResult():
        emit(
          state.copyWith(
            isPreferencesLoading: false,
            failure: result.failure,
          ),
        );
        return false;
    }
  }

  Future<bool> _updatePreferences(Map<String, dynamic> body) async {
    emit(state.copyWith(isPreferencesLoading: true, clearFailure: true));

    final result = await _updateNotificationPreferencesUseCase.call(body);
    switch (result) {
      case ApiSuccessResult(data: final prefs):
        emit(
          state.copyWith(
            isPreferencesLoading: false,
            preferences: prefs,
            clearFailure: true,
          ),
        );
        return true;
      case ApiErrorResult():
        emit(
          state.copyWith(
            isPreferencesLoading: false,
            failure: result.failure,
          ),
        );
        return false;
    }
  }

  @override
  Future<void> close() async {
    await _notificationSubscription.cancel();
    await _supportCaseChangedSubscription.cancel();
    return super.close();
  }
}
