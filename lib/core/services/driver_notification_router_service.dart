import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';

import 'app_navigator_service.dart';
import 'driver_notification_dedup_service.dart';
import 'driver_notification_payload_resolver.dart';

@lazySingleton
class DriverNotificationRouterService {
  DriverNotificationRouterService(this._navigatorService, this._dedupService);

  final AppNavigatorService _navigatorService;
  final DriverNotificationDedupService _dedupService;

  Map<String, dynamic>? _pendingPayload;
  bool _isNavigationUnlocked = false;
  bool _isRouting = false;

  void lockNavigation() {
    _isNavigationUnlocked = false;
  }

  Future<void> unlockNavigation() async {
    _isNavigationUnlocked = true;
    await resumePendingNavigationIfPossible();
  }

  void clearTransientState() {
    _pendingPayload = null;
    _isRouting = false;
  }

  Future<void> queuePendingPayload(Map<String, dynamic> payload) async {
    final normalizedPayload = DriverNotificationPayloadResolver.normalize(
      payload,
    );
    if (normalizedPayload.isEmpty) {
      return;
    }
    debugPrint(
      '[DriverNotificationRouter] Queued pending payload '
      '${DriverNotificationPayloadResolver.resolveDebugSummary(normalizedPayload)}',
    );
    _pendingPayload = normalizedPayload;
    await resumePendingNavigationIfPossible();
  }

  Future<void> handleNotificationTap(
    Map<String, dynamic> payload, {
    String source = 'unknown',
  }) async {
    final normalizedPayload = DriverNotificationPayloadResolver.normalize(
      payload,
    );
    if (normalizedPayload.isEmpty) {
      debugPrint(
        '[DriverNotificationRouter] Ignored empty notification payload from $source',
      );
      return;
    }

    final shouldProcess = _dedupService.markProcessed(
      normalizedPayload,
      namespace: 'notification_tap',
      ttl: const Duration(seconds: 6),
    );
    if (!shouldProcess) {
      debugPrint(
        '[DriverNotificationRouter] Skipped duplicate notification tap from $source',
      );
      return;
    }

    if (!_isNavigationUnlocked || _isRouting) {
      debugPrint(
        '[DriverNotificationRouter] Deferred navigation from $source '
        'unlocked=$_isNavigationUnlocked routing=$_isRouting '
        '${DriverNotificationPayloadResolver.resolveDebugSummary(normalizedPayload)}',
      );
      _pendingPayload = normalizedPayload;
      return;
    }

    await _navigateToPayload(normalizedPayload, source: source);
  }

  Future<void> resumePendingNavigationIfPossible() async {
    if (!_isNavigationUnlocked || _isRouting) {
      return;
    }

    final pendingPayload = _pendingPayload;
    if (pendingPayload == null || pendingPayload.isEmpty) {
      return;
    }

    _pendingPayload = null;
    await _navigateToPayload(pendingPayload, source: 'pending_resume');
  }

  Future<void> _navigateToPayload(
    Map<String, dynamic> payload, {
    required String source,
  }) async {
    if (_isRouting) {
      _pendingPayload = payload;
      return;
    }

    _isRouting = true;
    try {
      final screen = DriverNotificationPayloadResolver.resolveScreen(payload);
      debugPrint(
        '[DriverNotificationRouter] Routing payload from $source '
        'screen=${screen ?? '<null>'} '
        '${DriverNotificationPayloadResolver.resolveDebugSummary(payload)}',
      );
      switch (screen) {
        case 'home':
          await _navigatorService.resetToNamedWhenReady(
            AppRoutes.mainShell,
            arguments: {'initialIndex': 0},
          );
          return;
        case 'assignment_detail':
          final assignmentId =
              DriverNotificationPayloadResolver.resolveAssignmentId(payload);
          if ((assignmentId ?? '').trim().isEmpty) {
            break;
          }
          await _navigatorService.pushNamedWhenReady(
            AppRoutes.orderDetails,
            arguments: <String, dynamic>{'assignmentId': assignmentId},
          );
          return;
        case 'support_case_detail':
          final caseId = DriverNotificationPayloadResolver.resolveSupportCaseId(
            payload,
          );
          if ((caseId ?? '').trim().isEmpty) {
            break;
          }
          final caseType =
              DriverNotificationPayloadResolver.resolveSupportCaseType(payload);
          await _navigatorService.pushNamedWhenReady(
            AppRoutes.driverSupportCaseDetails,
            arguments: <String, dynamic>{
              'caseId': caseId,
              if ((caseType ?? '').trim().isNotEmpty) 'caseType': caseType,
            },
          );
          return;
        case 'wallet':
          await _navigatorService.resetToNamedWhenReady(
            AppRoutes.mainShell,
            arguments: {'initialIndex': 2},
          );
          return;
        case 'account_status':
          final event = DriverNotificationPayloadResolver.resolveEvent(payload);
          final normalizedEvent = event?.toLowerCase().trim() ?? '';
          if (normalizedEvent == 'account.document_rejected') {
            await _navigatorService.pushNamedWhenReady(
              AppRoutes.profileSecurityDocuments,
              arguments: payload,
            );
          } else if (normalizedEvent == 'account.document_approved') {
            await _navigatorService.pushNamedWhenReady(
              AppRoutes.profile,
              arguments: payload,
            );
          } else {
            await _navigatorService.pushNamedWhenReady(
              AppRoutes.profile,
              arguments: payload,
            );
          }
          return;
        case 'notifications_center':
          await _navigatorService.pushNamedWhenReady(AppRoutes.notifications);
          return;
        default:
          debugPrint(
            '[DriverNotificationRouter] Unknown screen "${screen ?? '<null>'}" from $source. '
            'Falling back to notifications center.',
          );
      }

      await _navigatorService.pushNamedWhenReady(AppRoutes.notifications);
    } finally {
      _isRouting = false;
      if (_pendingPayload != null && _isNavigationUnlocked) {
        unawaited(resumePendingNavigationIfPossible());
      }
    }
  }
}
