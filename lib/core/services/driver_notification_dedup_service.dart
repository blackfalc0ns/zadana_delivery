import 'package:injectable/injectable.dart';

import 'driver_notification_payload_resolver.dart';

@lazySingleton
class DriverNotificationDedupService {
  final Map<String, DateTime> _processedKeys = <String, DateTime>{};

  bool markProcessed(
    Map<String, dynamic> payload, {
    String namespace = 'default',
    Duration ttl = const Duration(minutes: 2),
  }) {
    final key = _resolveKey(payload);
    if (key == null) {
      return true;
    }

    _cleanupExpiredKeys(ttl);

    final scopedKey = '$namespace::$key';
    final lastProcessedAt = _processedKeys[scopedKey];
    if (lastProcessedAt != null &&
        DateTime.now().difference(lastProcessedAt) <= ttl) {
      return false;
    }

    _processedKeys[scopedKey] = DateTime.now();
    return true;
  }

  void clear() {
    _processedKeys.clear();
  }

  void _cleanupExpiredKeys(Duration ttl) {
    final expiredKeys = <String>[];
    final now = DateTime.now();
    _processedKeys.forEach((key, processedAt) {
      if (now.difference(processedAt) > ttl) {
        expiredKeys.add(key);
      }
    });

    for (final key in expiredKeys) {
      _processedKeys.remove(key);
    }
  }

  String? _resolveKey(Map<String, dynamic> payload) {
    final notificationId =
        DriverNotificationPayloadResolver.resolveNotificationId(payload);
    if (notificationId != null && notificationId.isNotEmpty) {
      return notificationId;
    }

    final parts = <String>[
      DriverNotificationPayloadResolver.resolveScreen(payload) ?? '',
      DriverNotificationPayloadResolver.resolveEvent(payload) ?? '',
      DriverNotificationPayloadResolver.resolveAssignmentId(payload) ?? '',
      DriverNotificationPayloadResolver.resolveOrderId(payload) ?? '',
      DriverNotificationPayloadResolver.resolveSupportCaseId(payload) ?? '',
      DriverNotificationPayloadResolver.resolveReferenceId(payload) ?? '',
    ].where((value) => value.trim().isNotEmpty).toList(growable: false);

    if (parts.isEmpty) {
      return null;
    }

    return parts.join('|');
  }
}
