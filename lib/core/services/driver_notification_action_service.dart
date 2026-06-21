import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/network/network_constants.dart';
import 'package:zadana_delivery/features/driver_home/domain/usecase/refresh_driver_home_usecase.dart';

import 'app_navigator_service.dart';
import 'driver_notification_router_service.dart';

@lazySingleton
class DriverNotificationActionService {
  DriverNotificationActionService(
    this._navigatorService,
    this._routerService,
  );

  final AppNavigatorService _navigatorService;
  final DriverNotificationRouterService _routerService;

  static const MethodChannel _channel = MethodChannel(
    NetworkConstants.nativeNotificationsChannel,
  );

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    _channel.setMethodCallHandler(_handleMethodCall);
    debugPrint('[DriverNotificationAction] Method call handler installed');

    // Check for any pending actions on startup
    await _consumePendingAction();
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onNotificationAction':
        final arguments = call.arguments as Map<Object?, Object?>?;
        if (arguments == null) return;

        final action = arguments['action']?.toString().trim() ?? '';
        final assignmentId = arguments['assignmentId']?.toString().trim() ?? '';
        final orderId = arguments['orderId']?.toString().trim() ?? '';
        final wasExecuted = arguments['wasExecuted'] as bool? ?? false;
        final wasSuccessful = arguments['wasSuccessful'] as bool? ?? false;
        final errorMessage = arguments['errorMessage']?.toString().trim() ?? '';

        debugPrint(
          '[DriverNotificationAction] Received notification action: '
          'action=$action, assignmentId=$assignmentId, executed=$wasExecuted, success=$wasSuccessful',
        );

        if (action.isEmpty || assignmentId.isEmpty) {
          debugPrint('[DriverNotificationAction] Ignoring invalid action');
          return;
        }

        // If action was already executed in native, just refresh and navigate
        if (wasExecuted) {
          await _handleExecutedAction(
            action,
            assignmentId,
            orderId,
            wasSuccessful,
            errorMessage,
          );
        }
        break;
    }
  }

  Future<void> _consumePendingAction() async {
    try {
      final result = await _channel.invokeMethod<Map<Object?, Object?>>(
        'consumePendingNotificationAction',
      );

      if (result == null || result.isEmpty) {
        return;
      }

      final action = result['action']?.toString().trim() ?? '';
      final assignmentId = result['assignmentId']?.toString().trim() ?? '';
      final orderId = result['orderId']?.toString().trim() ?? '';
      final wasExecuted = result['wasExecuted'] as bool? ?? false;
      final wasSuccessful = result['wasSuccessful'] as bool? ?? false;
      final errorMessage = result['errorMessage']?.toString().trim() ?? '';

      if (action.isEmpty || assignmentId.isEmpty) {
        return;
      }

      debugPrint(
        '[DriverNotificationAction] Consumed pending action: '
        'action=$action, assignmentId=$assignmentId, executed=$wasExecuted, success=$wasSuccessful',
      );

      // If action was already executed in native, just refresh and navigate
      if (wasExecuted) {
        await _handleExecutedAction(
          action,
          assignmentId,
          orderId,
          wasSuccessful,
          errorMessage,
        );
      }
    } catch (error) {
      debugPrint(
        '[DriverNotificationAction] Failed to consume pending action: $error',
      );
    }
  }

  Future<void> _handleExecutedAction(
    String action,
    String assignmentId,
    String orderId,
    bool wasSuccessful,
    String errorMessage,
  ) async {
    if (!wasSuccessful) {
      debugPrint(
        '[DriverNotificationAction] Action failed in native: $errorMessage',
      );
      // Action failed - error was already shown as Toast in native
      return;
    }

    debugPrint(
      '[DriverNotificationAction] Action succeeded in native, refreshing home',
    );

    // Refresh home to get updated state
    try {
      await getIt<RefreshDriverHomeUseCase>().call();
    } catch (error) {
      debugPrint('[DriverNotificationAction] Failed to refresh home: $error');
    }

    // Navigate to home after accepting an order
    if (action == 'accept') {
      await _navigatorService.waitUntilReady();
      unawaited(
        _routerService.handleNotificationTap(
          {'screen': 'home'},
          source: 'notification_action_accept_native',
        ),
      );
    }
  }
}
