import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:zadana_delivery/core/utils/constants.dart';

/// Provides a stable device identifier that persists across app sessions.
/// Reuses the same key as the notification device service for consistency.
@lazySingleton
class DeviceIdService {
  DeviceIdService(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;
  static const _uuid = Uuid();

  /// Returns the existing device ID or creates a new one.
  Future<String> getOrCreateDeviceId() async {
    final existing =
        _sharedPreferences.getString(AppConstants.notificationDeviceId)?.trim();
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final generated = _uuid.v4();
    await _sharedPreferences.setString(
      AppConstants.notificationDeviceId,
      generated,
    );
    return generated;
  }
}
