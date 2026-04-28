import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/notifications/domain/entities/driver_notification_entity.dart';
import 'package:zadana_delivery/features/notifications/domain/usecase/get_driver_notifications_unread_count_usecase.dart';
import 'package:zadana_delivery/features/notifications/domain/usecase/get_driver_notifications_usecase.dart';
import 'package:zadana_delivery/features/notifications/domain/usecase/mark_all_driver_notifications_read_usecase.dart';
import 'package:zadana_delivery/features/notifications/domain/usecase/mark_driver_notification_read_usecase.dart';
import 'package:zadana_delivery/features/notifications/presentation/manager/notifications_event.dart';
import 'package:zadana_delivery/features/notifications/presentation/manager/notifications_state.dart';

@injectable
class NotificationsViewModel extends Cubit<NotificationsState> {
  NotificationsViewModel(
    this._getDriverNotificationsUseCase,
    this._markDriverNotificationReadUseCase,
    this._markAllDriverNotificationsReadUseCase,
    this._getDriverNotificationsUnreadCountUseCase,
  ) : super(const NotificationsState());

  final GetDriverNotificationsUseCase _getDriverNotificationsUseCase;
  final MarkDriverNotificationReadUseCase _markDriverNotificationReadUseCase;
  final MarkAllDriverNotificationsReadUseCase
  _markAllDriverNotificationsReadUseCase;
  final GetDriverNotificationsUnreadCountUseCase
  _getDriverNotificationsUnreadCountUseCase;

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
      case NotificationsClearErrorEvent():
        _clearError();
        return true;
      case NotificationsMarkReadEvent():
        return _markAsRead(event.id);
      case NotificationsMarkAllReadEvent():
        return _markAllAsRead();
      case NotificationsRefreshUnreadCountEvent():
        return _refreshUnreadCount();
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

  void _clearError() {
    if (state.failure == null) return;
    emit(state.copyWith(clearFailure: true));
  }
}
