import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DriverNotificationLaunchPayloadService {
  static const MethodChannel _channel = MethodChannel(
    'zadana_delivery/notification_launch',
  );

  Future<Map<String, dynamic>> consumePendingPayload() async {
    if (kIsWeb) {
      return const <String, dynamic>{};
    }

    try {
      final result = await _channel.invokeMethod<dynamic>(
        'consumePendingPayload',
      );
      if (result is Map<String, dynamic>) {
        return result;
      }
      if (result is Map) {
        return Map<String, dynamic>.from(result);
      }
    } catch (error) {
      debugPrint(
        '[DriverNotificationLaunchPayload] Failed to consume pending payload: $error',
      );
    }

    return const <String, dynamic>{};
  }
}
