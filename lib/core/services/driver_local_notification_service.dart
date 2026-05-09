import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

import 'driver_notification_payload_resolver.dart';
import 'driver_notification_router_service.dart';

@pragma('vm:entry-point')
void driverLocalNotificationBackgroundTap(NotificationResponse response) {
  debugPrint(
    '[DriverLocalNotification] background tap received: '
    '${response.payload ?? '<empty>'}',
  );
}

@lazySingleton
class DriverLocalNotificationService {
  DriverLocalNotificationService(this._routerService);

  final DriverNotificationRouterService _routerService;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  Map<String, dynamic>? _initialLaunchPayload;

  Future<void> initialize() async {
    if (_isInitialized) return;

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          driverLocalNotificationBackgroundTap,
    );

    await _createAndroidChannels();
    await _restoreLaunchPayloadIfAvailable();

    _isInitialized = true;
  }

  Map<String, dynamic>? takeInitialLaunchPayload() {
    final payload = _initialLaunchPayload;
    _initialLaunchPayload = null;
    return payload;
  }

  Future<void> showPayloadNotification({
    required Map<String, dynamic> payload,
    required String title,
    String? body,
  }) async {
    await initialize();

    final normalizedPayload = DriverNotificationPayloadResolver.normalize(
      payload,
    );
    final notificationId =
        DriverNotificationPayloadResolver.resolveNotificationId(
          normalizedPayload,
        ) ??
        DateTime.now().microsecondsSinceEpoch.toString();

    final channelId = DriverNotificationPayloadResolver.resolveAndroidChannelId(
      normalizedPayload,
    );

    await _plugin.show(
      notificationId.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          _androidChannelName(channelId),
          channelDescription: _androidChannelDescription(channelId),
          importance: Importance.max,
          priority: Priority.max,
          visibility: NotificationVisibility.public,
          category: AndroidNotificationCategory.message,
          ticker: 'zadana_driver_notification',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentBanner: true,
          presentList: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(normalizedPayload),
    );
  }

  Future<void> _createAndroidChannels() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) {
      return;
    }

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        DriverNotificationPayloadResolver.headsUpChannelId,
        'Urgent driver updates',
        description: 'Urgent driver order, support, and account alerts.',
        importance: Importance.max,
      ),
    );

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        DriverNotificationPayloadResolver.generalChannelId,
        'Driver updates',
        description: 'General driver wallet, account, and assignment updates.',
        importance: Importance.high,
      ),
    );
  }

  Future<void> _restoreLaunchPayloadIfAvailable() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    final payload = details?.notificationResponse?.payload;
    if (!(details?.didNotificationLaunchApp ?? false) ||
        payload == null ||
        payload.trim().isEmpty) {
      return;
    }

    _initialLaunchPayload = _decodePayload(payload);
  }

  Future<void> _handleNotificationResponse(
    NotificationResponse response,
  ) async {
    final payload = _decodePayload(response.payload);
    if (payload.isEmpty) {
      return;
    }

    await _routerService.handleNotificationTap(
      payload,
      source: 'local_notification_tap',
    );
  }

  Map<String, dynamic> _decodePayload(String? rawPayload) {
    if (rawPayload == null || rawPayload.trim().isEmpty) {
      return const <String, dynamic>{};
    }

    try {
      final decoded = jsonDecode(rawPayload);
      if (decoded is Map) {
        return DriverNotificationPayloadResolver.normalize(
          Map<String, dynamic>.from(decoded),
        );
      }
    } catch (_) {
      // Ignore malformed payloads safely.
    }

    return const <String, dynamic>{};
  }

  String _androidChannelName(String channelId) {
    if (channelId == DriverNotificationPayloadResolver.headsUpChannelId) {
      return 'Urgent driver updates';
    }
    return 'Driver updates';
  }

  String _androidChannelDescription(String channelId) {
    if (channelId == DriverNotificationPayloadResolver.headsUpChannelId) {
      return 'Urgent driver order, support, and account alerts.';
    }
    return 'General driver wallet, account, and assignment updates.';
  }
}
