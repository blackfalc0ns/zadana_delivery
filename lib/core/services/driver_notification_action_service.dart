import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/network/network_constants.dart';
import 'package:zadana_delivery/features/driver_home/domain/usecase/accept_driver_offer_usecase.dart';
import 'package:zadana_delivery/features/driver_home/domain/usecase/refresh_driver_home_usecase.dart';
import 'package:zadana_delivery/features/driver_home/domain/usecase/reject_driver_offer_usecase.dart';

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
  bool _isProcessing = false;

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
        final orderTitle = arguments['orderTitle']?.toString().trim() ?? 'الطلب';

        debugPrint(
          '[DriverNotificationAction] Received notification action: '
          'action=$action, assignmentId=$assignmentId, orderId=$orderId, title=$orderTitle',
        );

        if (action.isEmpty || assignmentId.isEmpty) {
          debugPrint(
            '[DriverNotificationAction] Ignoring invalid action: '
            'action=$action, assignmentId=$assignmentId',
          );
          return;
        }

        await _showConfirmationDialogAndProcess(
          action,
          assignmentId,
          orderId,
          orderTitle,
        );
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
      final orderTitle = result['orderTitle']?.toString().trim() ?? 'الطلب';

      if (action.isEmpty || assignmentId.isEmpty) {
        return;
      }

      debugPrint(
        '[DriverNotificationAction] Consumed pending action: '
        'action=$action, assignmentId=$assignmentId, orderId=$orderId, title=$orderTitle',
      );

      await _showConfirmationDialogAndProcess(
        action,
        assignmentId,
        orderId,
        orderTitle,
      );
    } catch (error) {
      debugPrint(
        '[DriverNotificationAction] Failed to consume pending action: $error',
      );
    }
  }

  Future<void> _showConfirmationDialogAndProcess(
    String action,
    String assignmentId,
    String orderId,
    String orderTitle,
  ) async {
    await _navigatorService.waitUntilReady();
    final context = _navigatorService.currentContext;
    if (context == null) {
      debugPrint(
        '[DriverNotificationAction] No context available for dialog',
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(action == 'accept' ? 'قبول الطلب' : 'رفض الطلب'),
          content: Text(
            action == 'accept'
                ? 'هل تريد قبول $orderTitle؟'
                : 'هل تريد رفض $orderTitle؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(action == 'accept' ? 'قبول' : 'رفض'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _processAction(action, assignmentId, orderId);
    }
  }

  Future<void> _processAction(
    String action,
    String assignmentId,
    String orderId,
  ) async {
    if (_isProcessing) {
      debugPrint(
        '[DriverNotificationAction] Already processing an action, skipping: $action',
      );
      return;
    }

    _isProcessing = true;
    try {
      await _navigatorService.waitUntilReady();

      switch (action) {
        case 'accept':
          await _handleAccept(assignmentId, orderId);
          break;
        case 'reject':
          await _handleReject(assignmentId, orderId);
          break;
        default:
          debugPrint(
            '[DriverNotificationAction] Unknown action: $action',
          );
      }
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _handleAccept(String assignmentId, String orderId) async {
    debugPrint(
      '[DriverNotificationAction] Processing accept for assignmentId=$assignmentId',
    );

    try {
      // Execute accept offer use case
      final acceptUseCase = getIt<AcceptDriverOfferUseCase>();
      final result = await acceptUseCase.call(assignmentId);

      switch (result) {
        case ApiSuccessResult():
          debugPrint(
            '[DriverNotificationAction] Accept successful for assignmentId=$assignmentId',
          );
          // Refresh home to update UI
          unawaited(getIt<RefreshDriverHomeUseCase>().call());
          
          // Navigate to order details if we have the assignmentId
          if (assignmentId.isNotEmpty) {
            unawaited(
              _routerService.handleNotificationTap(
                {
                  'screen': 'assignment_detail',
                  'assignmentId': assignmentId,
                  'orderId': orderId,
                },
                source: 'notification_action_accept',
              ),
            );
          }
          break;
        case ApiErrorResult():
          debugPrint(
            '[DriverNotificationAction] Accept failed for assignmentId=$assignmentId',
          );
          break;
      }
    } catch (error) {
      debugPrint(
        '[DriverNotificationAction] Accept error for assignmentId=$assignmentId: $error',
      );
    }
  }

  Future<void> _handleReject(String assignmentId, String orderId) async {
    debugPrint(
      '[DriverNotificationAction] Processing reject for assignmentId=$assignmentId',
    );

    try {
      // Execute reject offer use case
      final rejectUseCase = getIt<RejectDriverOfferUseCase>();
      final result = await rejectUseCase.call(assignmentId);

      switch (result) {
        case ApiSuccessResult():
          debugPrint(
            '[DriverNotificationAction] Reject successful for assignmentId=$assignmentId',
          );
          // Refresh home to update UI
          unawaited(getIt<RefreshDriverHomeUseCase>().call());
          break;
        case ApiErrorResult():
          debugPrint(
            '[DriverNotificationAction] Reject failed for assignmentId=$assignmentId',
          );
          break;
      }
    } catch (error) {
      debugPrint(
        '[DriverNotificationAction] Reject error for assignmentId=$assignmentId: $error',
      );
    }
  }
}
