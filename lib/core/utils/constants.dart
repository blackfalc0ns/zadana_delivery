/// Application-wide constants used across the project.
abstract class AppConstants {
  // 🔹 Shared Preferences Keys
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';
  static const String isAccessTokenSaved = 'isAccessTokenSaved';
  static const String isRefreshTokenSaved = 'isRefreshTokenSaved';
  static const String currentUserId = 'currentUserId';
  static const String notificationsEnabled = 'notificationsEnabled';
  static const String notificationDeviceId = 'notificationDeviceId';
  static const String notificationPushToken = 'notificationPushToken';
  static const String notificationPushSubscriptionId =
      'notificationPushSubscriptionId';
  static const String isRemember = 'isRemember';
  static const String driverId = 'driverId';
  static const String driverFullName = 'driverFullName';
  static const String driverEmail = 'driverEmail';
  static const String driverPhone = 'driverPhone';
  static const String driverRole = 'driverRole';
  static const String driverLastIdentifier = 'driverLastIdentifier';
  static const String driverProfileDraft = 'driverProfileDraft';
  static const String isDriverProfileCompleted = 'isDriverProfileCompleted';

  // 🔹 Localization Keys
  static const String languageCode = 'languageCode';
  static const String arKey = 'ar';
  static const String enKey = 'en';

  // 🔹 darkAndLight Keys
  static const String isDark = 'false';

  // 🔹 General Constants
  static const String noInternet = 'No Internet Connection';
  static const int animateSeconds = 300;
  static const double blurSigma = 10;
  static const String helpContentKey = "help_screen_content";
  static const String privacyPolicyContentKey = "privacy_policy";
  static const String securityRolesContentKey = "security_roles_config";
}
