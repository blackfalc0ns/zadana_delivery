import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';

import 'app_navigator_service.dart';
import 'driver_notification_dedup_service.dart';
import 'driver_notification_device_service.dart';
import 'driver_local_notification_service.dart';
import 'driver_notification_payload_resolver.dart';
import 'driver_notification_router_service.dart';
import 'driver_realtime_service.dart';

class _QueuedOverlayBanner {
  const _QueuedOverlayBanner({
    required this.payload,
    required this.source,
    this.title,
    this.body,
  });

  final Map<String, dynamic> payload;
  final String source;
  final String? title;
  final String? body;
}

@lazySingleton
class DriverNotificationOverlayService {
  DriverNotificationOverlayService(
    this._navigatorService,
    this._routerService,
    this._dedupService,
    this._driverRealtimeService,
    this._localNotificationService,
    this._deviceService,
  );

  final AppNavigatorService _navigatorService;
  final DriverNotificationRouterService _routerService;
  final DriverNotificationDedupService _dedupService;
  final DriverRealtimeService _driverRealtimeService;
  final DriverLocalNotificationService _localNotificationService;
  final DriverNotificationDeviceService _deviceService;

  static const Duration _overlayDuration = Duration(seconds: 4);
  static const Duration _overlayGap = Duration(milliseconds: 250);
  static const Duration _overlayContextRetryDelay = Duration(milliseconds: 200);
  static const int _overlayContextRetryAttempts = 15;

  StreamSubscription<Map<String, dynamic>>? _notificationSubscription;
  StreamSubscription<Map<String, dynamic>>? _deliveryOfferSubscription;
  StreamSubscription<Map<String, dynamic>>? _assignmentUpdatedSubscription;
  StreamSubscription<Map<String, dynamic>>? _orderStatusSubscription;
  StreamSubscription<Map<String, dynamic>>? _supportCaseChangedSubscription;
  StreamSubscription<Map<String, dynamic>>? _driverHomeUpdatedSubscription;
  StreamSubscription<Map<String, dynamic>>? _driverWalletUpdatedSubscription;
  final ListQueue<_QueuedOverlayBanner> _pendingBanners =
      ListQueue<_QueuedOverlayBanner>();
  bool _isStarted = false;
  bool _isProcessingPendingBanners = false;

  void startListening() {
    if (_isStarted) return;
    _isStarted = true;

    _notificationSubscription = _driverRealtimeService.notifications.listen(
      (payload) => showPayloadBanner(payload, source: 'signalr_notification'),
    );

    _deliveryOfferSubscription = _driverRealtimeService.deliveryOffers.listen(
      (payload) => showPayloadBanner(
        payload,
        title: 'New delivery offer',
        body: 'Tap to open the latest assignment update.',
        source: 'signalr_delivery_offer',
      ),
    );

    _assignmentUpdatedSubscription = _driverRealtimeService.assignmentUpdated
        .listen(
          (payload) => showPayloadBanner(
            payload,
            title: 'Assignment updated',
            body: 'Your current assignment details were refreshed.',
            source: 'signalr_assignment_updated',
          ),
        );

    _orderStatusSubscription = _driverRealtimeService.orderStatusChanged.listen(
      (payload) => showPayloadBanner(
        payload,
        title: 'Order status updated',
        body: 'Tap to review the latest delivery progress.',
        source: 'signalr_order_status_changed',
      ),
    );

    _supportCaseChangedSubscription = _driverRealtimeService.supportCaseChanged
        .listen(
          (payload) => showPayloadBanner(
            payload,
            title: 'Support update',
            body: 'There is a new update on your support case.',
            source: 'signalr_support_case_changed',
          ),
        );

    _driverHomeUpdatedSubscription = _driverRealtimeService.driverHomeUpdated
        .listen(
          (payload) => showPayloadBanner(
            payload,
            title: 'Driver home updated',
            body: 'Your dashboard status has been refreshed.',
            source: 'signalr_driver_home_updated',
          ),
        );

    _driverWalletUpdatedSubscription = _driverRealtimeService
        .driverWalletUpdated
        .listen(
          (payload) => showPayloadBanner(
            payload,
            title: 'Wallet updated',
            body: 'Your latest wallet balance is now available.',
            source: 'signalr_driver_wallet_updated',
          ),
        );
  }

  Future<void> showPayloadBanner(
    Map<String, dynamic> payload, {
    String? title,
    String? body,
    String source = 'unknown',
  }) async {
    final normalizedPayload = DriverNotificationPayloadResolver.normalize(
      payload,
    );
    if (normalizedPayload.isEmpty) {
      return;
    }

    final shouldShow = _dedupService.markProcessed(
      normalizedPayload,
      namespace: 'overlay_banner',
      ttl: const Duration(seconds: 8),
    );
    if (!shouldShow) {
      return;
    }

    // SignalR keeps the UI in sync, but it does not create an iOS/Android
    // system notification by itself. Mirror actual notification-feed events
    // to a local notification while the app is active.
    if (source == 'signalr_notification') {
      await _showRealtimeSystemNotification(normalizedPayload);
    }

    _pendingBanners.add(
      _QueuedOverlayBanner(
        payload: normalizedPayload,
        title: title,
        body: body,
        source: source,
      ),
    );
    unawaited(_processPendingBanners());
  }

  Future<void> _showRealtimeSystemNotification(
    Map<String, dynamic> payload,
  ) async {
    try {
      if (!await _deviceService.isPushEnabled()) {
        debugPrint(
          '[DriverNotificationOverlay] System notification skipped because notifications are disabled.',
        );
        return;
      }

      final content = DriverNotificationPayloadResolver.resolveDisplayContent(
        payload: payload,
      );
      if (!content.hasVisibleContent) {
        debugPrint(
          '[DriverNotificationOverlay] System notification skipped because it has no visible content.',
        );
        return;
      }

      await _localNotificationService.showPayloadNotification(
        payload: payload,
        title: content.title,
        body: content.body,
      );
      debugPrint(
        '[DriverNotificationOverlay] SignalR notification displayed via local notification.',
      );
    } catch (error) {
      // The in-app banner remains available if local notification display
      // fails for any platform-specific reason.
      debugPrint(
        '[DriverNotificationOverlay] Failed to display SignalR local notification: $error',
      );
    }
  }

  Future<void> _processPendingBanners() async {
    if (_isProcessingPendingBanners) {
      return;
    }

    _isProcessingPendingBanners = true;
    try {
      while (_pendingBanners.isNotEmpty) {
        final overlayContextReady = await _waitForOverlayContext();
        if (!overlayContextReady) {
          debugPrint(
            '[DriverNotificationOverlay] Banner is waiting for a navigator context.',
          );
          return;
        }

        final queuedBanner = _pendingBanners.removeFirst();
        _showBannerNow(queuedBanner);
        await Future<void>.delayed(_overlayDuration + _overlayGap);
      }
    } finally {
      _isProcessingPendingBanners = false;
      if (_pendingBanners.isNotEmpty) {
        unawaited(_retryPendingBanners());
      }
    }
  }

  Future<void> _retryPendingBanners() async {
    await Future<void>.delayed(_overlayContextRetryDelay);
    await _processPendingBanners();
  }

  Future<bool> _waitForOverlayContext() async {
    await _navigatorService.waitUntilReady();

    for (var attempt = 0; attempt < _overlayContextRetryAttempts; attempt++) {
      final overlayContext =
          _navigatorService.navigator?.overlay?.context ??
          _navigatorService.currentContext;
      if (overlayContext != null) {
        return true;
      }

      await WidgetsBinding.instance.endOfFrame;
      await Future<void>.delayed(_overlayContextRetryDelay);
    }

    return false;
  }

  void _showBannerNow(_QueuedOverlayBanner banner) {
    final overlayContext =
        _navigatorService.navigator?.overlay?.context ??
        _navigatorService.currentContext;
    if (overlayContext == null) {
      debugPrint(
        '[DriverNotificationOverlay] Overlay context disappeared before banner display.',
      );
      return;
    }

    final message = DriverNotificationPayloadResolver.resolveBannerMessage(
      banner.payload,
      title: banner.title,
      body: banner.body,
    );
    if (message.trim().isEmpty) {
      debugPrint(
        '[DriverNotificationOverlay] Skipped empty banner from ${banner.source}.',
      );
      return;
    }

    debugPrint(
      '[DriverNotificationOverlay] Displaying in-app banner from ${banner.source}. '
      '${DriverNotificationPayloadResolver.resolveDebugSummary(banner.payload, title: banner.title, body: banner.body)}',
    );
    CustomSnackbar.showTopBanner(
      context: overlayContext,
      message: message,
      duration: _overlayDuration,
      onTap: () {
        unawaited(
          _routerService.handleNotificationTap(
            banner.payload,
            source: '${banner.source}_banner_tap',
          ),
        );
      },
    );
  }

  Future<void> dispose() async {
    await _notificationSubscription?.cancel();
    await _deliveryOfferSubscription?.cancel();
    await _assignmentUpdatedSubscription?.cancel();
    await _orderStatusSubscription?.cancel();
    await _supportCaseChangedSubscription?.cancel();
    await _driverHomeUpdatedSubscription?.cancel();
    await _driverWalletUpdatedSubscription?.cancel();
    _pendingBanners.clear();
    _notificationSubscription = null;
    _deliveryOfferSubscription = null;
    _assignmentUpdatedSubscription = null;
    _orderStatusSubscription = null;
    _supportCaseChangedSubscription = null;
    _driverHomeUpdatedSubscription = null;
    _driverWalletUpdatedSubscription = null;
    _isStarted = false;
    _isProcessingPendingBanners = false;
  }
}
