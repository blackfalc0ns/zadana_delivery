import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'app_navigator_service.dart';
import 'driver_local_notification_service.dart';
import 'driver_notification_device_service.dart';
import 'driver_notification_launch_payload_service.dart';
import 'driver_notification_overlay_service.dart';
import 'driver_notification_payload_resolver.dart';
import 'driver_notification_router_service.dart';
import 'token_service.dart';

@lazySingleton
class DriverNotificationBootstrapService {
  DriverNotificationBootstrapService(
    this._navigatorService,
    this._localNotificationService,
    this._deviceService,
    this._launchPayloadService,
    this._overlayService,
    this._routerService,
    this._tokenService,
  );

  static const String _defaultDriverOneSignalAppId =
      '1eead1ea-3d6f-4f2a-8bc5-c681d71b55f6';
  static const String _configuredDriverOneSignalAppId = String.fromEnvironment(
    'DRIVER_ONESIGNAL_APP_ID',
    defaultValue: _defaultDriverOneSignalAppId,
  );
  static const MethodChannel _nativeNotificationsChannel = MethodChannel(
    'zadana_delivery/native_notifications',
  );
  static final RegExp _uuidPattern = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );

  final AppNavigatorService _navigatorService;
  final DriverLocalNotificationService _localNotificationService;
  final DriverNotificationDeviceService _deviceService;
  final DriverNotificationLaunchPayloadService _launchPayloadService;
  final DriverNotificationOverlayService _overlayService;
  final DriverNotificationRouterService _routerService;
  final TokenService _tokenService;

  bool _isInitialized = false;
  Future<void>? _initializationFuture;
  Timer? _subscriptionRetryTimer;
  bool _hasRequestedNotificationPermission = false;
  bool _isNotificationsSettingsDialogVisible = false;
  bool _isNotificationsSettingsDialogScheduled = false;
  bool _isNotificationPermissionDeferredUntilUiReady = false;
  bool _useNativeAndroidForegroundFallback = false;

  late final String _driverOneSignalAppId = _resolveDriverOneSignalAppId();

  bool get isConfigured => _driverOneSignalAppId.trim().isNotEmpty;

  Future<void> initialize() async {
    if (_isInitialized) return;

    final inFlightInitialization = _initializationFuture;
    if (inFlightInitialization != null) {
      await inFlightInitialization;
      return;
    }

    final initialization = _initializeInternal();
    _initializationFuture = initialization;
    await initialization;
  }

  Future<void> prepareAuthenticatedPush(String userId) async {
    await initialize();
    if (!isConfigured) return;

    final normalizedUserId = userId.trim();
    if (normalizedUserId.isEmpty) return;

    try {
      await OneSignal.login(normalizedUserId);
      await _prepareSubscriptionAtBootstrap(context: 'authenticated_login');
      if (OneSignal.Notifications.permission) {
        await _deviceService.cachePushToken(
          OneSignal.User.pushSubscription.token,
          subscriptionId: OneSignal.User.pushSubscription.id,
        );
      }
      _logCurrentSubscriptionState(
        context: 'authenticated_login',
        userId: normalizedUserId,
      );
      await _logUserAndSubscriptionStatus(context: 'authenticated_login');
    } catch (error) {
      debugPrint(
        '[DriverNotificationBootstrap] Failed to prepare authenticated push: $error',
      );
    }
  }

  Future<void> restoreAuthenticatedPushIfPossible() async {
    final accessToken = await _tokenService.getToken();
    final userId = await _tokenService.getCurrentUserId();
    if ((accessToken ?? '').trim().isEmpty || (userId ?? '').trim().isEmpty) {
      return;
    }

    await prepareAuthenticatedPush(userId!);
  }

  Future<void> logoutPush() async {
    if (!_isInitialized || !isConfigured) {
      return;
    }

    try {
      await OneSignal.logout();
    } catch (error) {
      debugPrint(
        '[DriverNotificationBootstrap] Failed to log out OneSignal user: $error',
      );
    }
  }

  Future<void> requestNotificationPermissionAfterUiReady() async {
    await initialize();
    if (!isConfigured) {
      return;
    }

    if (!OneSignal.Notifications.permission ||
        _isNotificationPermissionDeferredUntilUiReady) {
      await _prepareSubscriptionAtBootstrap(context: 'ui_ready');
    }

    if (OneSignal.Notifications.permission) {
      await _deviceService.cachePushToken(
        OneSignal.User.pushSubscription.token,
        subscriptionId: OneSignal.User.pushSubscription.id,
      );
      _logCurrentSubscriptionState(context: 'ui_ready');
      await _logUserAndSubscriptionStatus(context: 'ui_ready');
    }
  }

  Future<void> _initializeInternal() async {
    try {
      await _localNotificationService.initialize();
      final initialLaunchPayload = _localNotificationService
          .takeInitialLaunchPayload();
      if (initialLaunchPayload != null &&
          initialLaunchPayload.isNotEmpty &&
          DriverNotificationPayloadResolver.isLikelyNotificationPayload(
            initialLaunchPayload,
          )) {
        await _routerService.queuePendingPayload(initialLaunchPayload);
      } else if (initialLaunchPayload != null &&
          initialLaunchPayload.isNotEmpty) {
        debugPrint(
          '[DriverNotificationBootstrap] Ignored local launch payload because it does not look like a notification payload.',
        );
      }
      final nativeLaunchPayload = await _launchPayloadService
          .consumePendingPayload();
      if (nativeLaunchPayload.isNotEmpty &&
          DriverNotificationPayloadResolver.isLikelyNotificationPayload(
            nativeLaunchPayload,
          )) {
        await _routerService.queuePendingPayload(nativeLaunchPayload);
      } else if (nativeLaunchPayload.isNotEmpty) {
        debugPrint(
          '[DriverNotificationBootstrap] Ignored native launch payload because it does not look like a notification payload.',
        );
      }

      if (!isConfigured) {
        debugPrint(
          '[DriverNotificationBootstrap] DRIVER_ONESIGNAL_APP_ID is empty. '
          'Foreground overlays and local notifications are ready, but remote push must be configured with the driver OneSignal app id.',
        );
        _isInitialized = true;
        return;
      }

      await OneSignal.initialize(_driverOneSignalAppId);
      debugPrint(
        '[DriverNotificationBootstrap] OneSignal initialized with appId=$_driverOneSignalAppId',
      );
      await _installNativeAndroidForegroundFallbackIfAvailable();
      await _logPlatformConfiguration();

      OneSignal.Notifications.addPermissionObserver((permission) {
        debugPrint(
          '[DriverNotificationBootstrap] Notification permission changed: $permission',
        );
        if (permission) {
          unawaited(
            _deviceService.cachePushToken(
              OneSignal.User.pushSubscription.token,
              subscriptionId: OneSignal.User.pushSubscription.id,
            ),
          );
        }
      });

      OneSignal.User.pushSubscription.addObserver((state) {
        debugPrint(
          '[DriverNotificationBootstrap] Push subscription changed: '
          'id=${state.current.id}, hasToken=${(state.current.token ?? '').trim().isNotEmpty}, '
          'optedIn=${state.current.optedIn}',
        );
        if ((state.current.id ?? '').trim().isEmpty ||
            (state.current.token ?? '').trim().isEmpty) {
          _scheduleSubscriptionRetry('subscription_observer');
        }
        unawaited(
          _deviceService.cachePushToken(
            state.current.token,
            subscriptionId: state.current.id,
          ),
        );
      });

      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        unawaited(_handleForegroundNotification(event));
      });

      OneSignal.Notifications.addClickListener((event) {
        final normalizedPayload = DriverNotificationPayloadResolver.normalize(
          event.notification.additionalData != null
              ? Map<String, dynamic>.from(event.notification.additionalData!)
              : const <String, dynamic>{},
        );
        unawaited(
          _routerService.handleNotificationTap(
            normalizedPayload,
            source: 'onesignal_click',
          ),
        );
      });

      if (OneSignal.Notifications.permission) {
        await _prepareSubscriptionAtBootstrap(context: 'bootstrap');
        await _deviceService.cachePushToken(
          OneSignal.User.pushSubscription.token,
          subscriptionId: OneSignal.User.pushSubscription.id,
        );
        _logCurrentSubscriptionState(context: 'bootstrap');
        await _logUserAndSubscriptionStatus(context: 'bootstrap');
      } else {
        _isNotificationPermissionDeferredUntilUiReady = true;
        debugPrint(
          '[DriverNotificationBootstrap] Notification permission prompt deferred until the app UI is ready.',
        );
      }

      _isInitialized = true;
    } catch (error) {
      debugPrint(
        '[DriverNotificationBootstrap] Initialization fallback after error: $error',
      );
      _isInitialized = true;
    } finally {
      _initializationFuture = null;
    }
  }

  Future<void> _prepareSubscriptionAtBootstrap({
    required String context,
  }) async {
    await OneSignal.User.pushSubscription.optIn();
    if (!OneSignal.Notifications.permission) {
      if (!_navigatorService.isReady) {
        _isNotificationPermissionDeferredUntilUiReady = true;
        debugPrint(
          '[DriverNotificationBootstrap] Notification permission request deferred [$context] until a visible app UI is available.',
        );
        return;
      }

      await _requestNotificationPermissionIfNeeded(context: context);
    }
    _isNotificationPermissionDeferredUntilUiReady = false;
    await _waitForSubscriptionReady(context: context);
  }

  void _logCurrentSubscriptionState({required String context, String? userId}) {
    debugPrint(
      '[DriverNotificationBootstrap] Subscription[$context] '
      'userId=${userId ?? '-'} '
      'permission=${OneSignal.Notifications.permission} '
      'subscriptionId=${OneSignal.User.pushSubscription.id ?? '-'} '
      'hasToken=${(OneSignal.User.pushSubscription.token ?? '').trim().isNotEmpty} '
      'optedIn=${OneSignal.User.pushSubscription.optedIn}',
    );
  }

  Future<void> _requestNotificationPermissionIfNeeded({
    required String context,
  }) async {
    final hasPermissionBeforeRequest = OneSignal.Notifications.permission;
    final canRequestPermission = await OneSignal.Notifications.canRequest();

    debugPrint(
      '[DriverNotificationBootstrap] Notification permission status before request '
      '[$context]: granted=$hasPermissionBeforeRequest canRequest=$canRequestPermission',
    );

    if (hasPermissionBeforeRequest) {
      debugPrint(
        '[DriverNotificationBootstrap] Notification permission already granted [$context].',
      );
      return;
    }

    if (_hasRequestedNotificationPermission && !canRequestPermission) {
      debugPrint(
        '[DriverNotificationBootstrap] Notification permission request skipped [$context] '
        'because the system prompt is no longer available.',
      );
      _scheduleNotificationsSettingsDialog();
      return;
    }

    _hasRequestedNotificationPermission = true;
    debugPrint(
      '[DriverNotificationBootstrap] Notification permission requested [$context].',
    );
    final permissionGranted = await OneSignal.Notifications.requestPermission(
      true,
    );
    debugPrint(
      '[DriverNotificationBootstrap] Notification permission result [$context]: '
      'requestedResult=$permissionGranted currentPermission=${OneSignal.Notifications.permission}',
    );

    if (!permissionGranted || !OneSignal.Notifications.permission) {
      _scheduleNotificationsSettingsDialog();
    }
  }

  Future<void> _waitForSubscriptionReady({required String context}) async {
    const maxAttempts = 10;
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      final subscriptionId = OneSignal.User.pushSubscription.id?.trim() ?? '';
      final token = OneSignal.User.pushSubscription.token?.trim() ?? '';
      if (subscriptionId.isNotEmpty && token.isNotEmpty) {
        if (attempt > 1) {
          debugPrint(
            '[DriverNotificationBootstrap] Subscription became ready after '
            '$attempt attempts during $context.',
          );
        }
        _cancelSubscriptionRetry();
        return;
      }

      if (attempt == 1 || attempt == maxAttempts) {
        debugPrint(
          '[DriverNotificationBootstrap] Waiting for OneSignal subscription during '
          '$context: attempt=$attempt/$maxAttempts permission=${OneSignal.Notifications.permission} '
          'subscriptionId=${subscriptionId.isEmpty ? "-" : subscriptionId} '
          'hasToken=${token.isNotEmpty}',
        );
      }
      await Future<void>.delayed(const Duration(seconds: 1));
    }

    _scheduleSubscriptionRetry(context);
    _logCurrentSubscriptionState(context: '${context}_not_ready');
    await _logUserAndSubscriptionStatus(context: '${context}_not_ready');
    _logMissingPushPrerequisites();
  }

  void _scheduleSubscriptionRetry(String source) {
    if (_subscriptionRetryTimer != null) {
      return;
    }

    debugPrint(
      '[DriverNotificationBootstrap] Scheduling OneSignal subscription retry from $source.',
    );
    _subscriptionRetryTimer = Timer(const Duration(seconds: 5), () async {
      _subscriptionRetryTimer = null;
      try {
        await _prepareSubscriptionAtBootstrap(context: 'retry_$source');
        await _deviceService.cachePushToken(
          OneSignal.User.pushSubscription.token,
          subscriptionId: OneSignal.User.pushSubscription.id,
        );
        _logCurrentSubscriptionState(context: 'retry_$source');
      } catch (error) {
        debugPrint(
          '[DriverNotificationBootstrap] Subscription retry failed from $source: $error',
        );
      }
    });
  }

  void _cancelSubscriptionRetry() {
    _subscriptionRetryTimer?.cancel();
    _subscriptionRetryTimer = null;
  }

  Future<void> _logPlatformConfiguration() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final platform = kIsWeb
          ? 'web'
          : Platform.isAndroid
          ? 'android'
          : Platform.isIOS
          ? 'ios'
          : Platform.operatingSystem;
      debugPrint(
        '[DriverNotificationBootstrap] OneSignal platform configuration: '
        'platform=$platform package=${packageInfo.packageName} '
        'version=${packageInfo.version} appId=$_driverOneSignalAppId',
      );
    } catch (error) {
      debugPrint(
        '[DriverNotificationBootstrap] Failed to inspect platform configuration: $error',
      );
    }
  }

  Future<void> _logUserAndSubscriptionStatus({required String context}) async {
    try {
      final externalId = await OneSignal.User.getExternalId();
      final oneSignalId = await OneSignal.User.getOnesignalId();
      debugPrint(
        '[DriverNotificationBootstrap] User[$context] '
        'externalId=${(externalId ?? '').trim().isEmpty ? "-" : externalId} '
        'oneSignalId=${(oneSignalId ?? '').trim().isEmpty ? "-" : oneSignalId} '
        'subscriptionId=${OneSignal.User.pushSubscription.id ?? '-'} '
        'hasToken=${(OneSignal.User.pushSubscription.token ?? '').trim().isNotEmpty} '
        'optedIn=${OneSignal.User.pushSubscription.optedIn}',
      );
    } catch (error) {
      debugPrint(
        '[DriverNotificationBootstrap] Failed to inspect OneSignal user state [$context]: $error',
      );
    }
  }

  String _resolveDriverOneSignalAppId() {
    final configuredAppId = _configuredDriverOneSignalAppId.trim();
    if (configuredAppId.isEmpty) {
      return '';
    }

    if (_uuidPattern.hasMatch(configuredAppId)) {
      return configuredAppId;
    }

    debugPrint(
      '[DriverNotificationBootstrap] Ignoring malformed DRIVER_ONESIGNAL_APP_ID '
      '"$configuredAppId" and falling back to $_defaultDriverOneSignalAppId.',
    );
    return _defaultDriverOneSignalAppId;
  }

  void _logMissingPushPrerequisites() {
    if (kIsWeb) {
      return;
    }

    final subscriptionId = OneSignal.User.pushSubscription.id?.trim() ?? '';
    final token = OneSignal.User.pushSubscription.token?.trim() ?? '';
    if (subscriptionId.isNotEmpty && token.isNotEmpty) {
      return;
    }

    final permission = OneSignal.Notifications.permission;
    if (Platform.isAndroid) {
      debugPrint(
        '[DriverNotificationBootstrap] Android push subscription is still incomplete. '
        'permission=$permission subscriptionId=${subscriptionId.isEmpty ? "-" : subscriptionId} '
        'hasToken=${token.isNotEmpty}. Ensure the driver app includes a valid '
        'android/app/google-services.json for package com.example.zadana_delivery '
        'and that notification permission is granted on the real device.',
      );
      return;
    }

    debugPrint(
      '[DriverNotificationBootstrap] Push subscription is still incomplete. '
      'permission=$permission subscriptionId=${subscriptionId.isEmpty ? "-" : subscriptionId} '
      'hasToken=${token.isNotEmpty}.',
    );
  }

  void _scheduleNotificationsSettingsDialog() {
    if (_isNotificationsSettingsDialogVisible ||
        _isNotificationsSettingsDialogScheduled) {
      return;
    }

    _isNotificationsSettingsDialogScheduled = true;
    unawaited(_showNotificationsSettingsDialogWhenReady());
  }

  Future<void> _showNotificationsSettingsDialogWhenReady() async {
    try {
      await _navigatorService.waitUntilReady();
      final context =
          _navigatorService.navigator?.overlay?.context ??
          _navigatorService.currentContext;
      if (context == null || !context.mounted) {
        return;
      }
      if (OneSignal.Notifications.permission) {
        return;
      }

      _isNotificationsSettingsDialogVisible = true;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Enable notifications'),
            content: const Text(
              'Driver alerts are currently turned off. Please enable notifications from app settings so you can receive delivery offers and account updates.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Later'),
              ),
              FilledButton(
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  final opened = await Geolocator.openAppSettings();
                  debugPrint(
                    '[DriverNotificationBootstrap] Open app settings tapped: opened=$opened',
                  );
                },
                child: const Text('Open Settings'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      debugPrint(
        '[DriverNotificationBootstrap] Failed to show notifications settings dialog: $error',
      );
    } finally {
      _isNotificationsSettingsDialogVisible = false;
      _isNotificationsSettingsDialogScheduled = false;
    }
  }

  Future<void> _handleForegroundNotification(
    OSNotificationWillDisplayEvent event,
  ) async {
    final normalizedPayload = DriverNotificationPayloadResolver.normalize(
      event.notification.additionalData != null
          ? Map<String, dynamic>.from(event.notification.additionalData!)
          : const <String, dynamic>{},
    );
    debugPrint(
      '[DriverNotificationBootstrap] Foreground push received. '
      '${DriverNotificationPayloadResolver.resolveDebugSummary(normalizedPayload, title: event.notification.title, body: event.notification.body)}',
    );
    final displayContent =
        DriverNotificationPayloadResolver.resolveDisplayContent(
          payload: normalizedPayload,
          title: event.notification.title,
          body: event.notification.body,
        );

    if (!displayContent.hasVisibleContent) {
      debugPrint(
        '[DriverNotificationBootstrap] Foreground push arrived without visible title/body. '
        '${DriverNotificationPayloadResolver.resolveDebugSummary(normalizedPayload, title: event.notification.title, body: event.notification.body)}',
      );
      return;
    }

    event.preventDefault();

    if (_useNativeAndroidForegroundFallback) {
      debugPrint(
        '[DriverNotificationBootstrap] Native Android foreground fallback is handling the system notification display. '
        '${DriverNotificationPayloadResolver.resolveDebugSummary(normalizedPayload, title: displayContent.title, body: displayContent.body)}',
      );
    } else {
      await _localNotificationService.showPayloadNotification(
        payload: normalizedPayload,
        title: displayContent.title,
        body: displayContent.body,
      );
      debugPrint(
        '[DriverNotificationBootstrap] Foreground push displayed via local notification. '
        '${DriverNotificationPayloadResolver.resolveDebugSummary(normalizedPayload, title: displayContent.title, body: displayContent.body)}',
      );
    }
    await _overlayService.showPayloadBanner(
      normalizedPayload,
      title: displayContent.title,
      body: displayContent.body,
      source: 'onesignal_foreground',
    );
    debugPrint(
      '[DriverNotificationBootstrap] Foreground push queued for in-app banner. '
      '${DriverNotificationPayloadResolver.resolveDebugSummary(normalizedPayload, title: displayContent.title, body: displayContent.body)}',
    );
  }

  Future<void> _installNativeAndroidForegroundFallbackIfAvailable() async {
    if (kIsWeb || !Platform.isAndroid) {
      _useNativeAndroidForegroundFallback = false;
      return;
    }

    try {
      final installed =
          await _nativeNotificationsChannel.invokeMethod<bool>(
            'installNativeForegroundFallback',
          ) ??
          false;
      _useNativeAndroidForegroundFallback = installed;
      debugPrint(
        '[DriverNotificationBootstrap] Native Android foreground fallback installed: $installed',
      );
    } catch (error) {
      _useNativeAndroidForegroundFallback = false;
      debugPrint(
        '[DriverNotificationBootstrap] Failed to install native Android foreground fallback: $error',
      );
    }
  }
}
