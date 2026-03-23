/// ─────────────────────────────────────────────────────────────
/// Global string keys used for Hive / SecureStorage / SharedPrefs.
/// One place → no typo bugs.
/// ─────────────────────────────────────────────────────────────
class StorageKeys {
  StorageKeys._();

  // ── Auth ──
  static const String authToken = 'auth_token';
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userData = 'user_data';

  // ── App settings ──
  static const String languageCode = 'language_code';
  static const String themeMode = 'theme_mode';
  static const String isFirstLaunch = 'is_first_launch';
  static const String fcmToken = 'fcm_token';

  // ── Cache timestamps ──
  static const String lastSync = 'last_sync';
  static const String cacheExpiry = 'cache_expiry';
}

/// Miscellaneous constant keys (intent extras, route args, etc.)
class ArgKeys {
  ArgKeys._();

  static const String id = 'id';
  static const String type = 'type';
  static const String title = 'title';
  static const String data = 'data';
  static const String url = 'url';
  static const String isEditing = 'is_editing';
}
