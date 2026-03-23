/// ─────────────────────────────────────────────────────────────
/// App‑wide constants. Values that NEVER change at runtime.
/// ─────────────────────────────────────────────────────────────
class AppConstants {
  AppConstants._();

  // ── App info ──
  static const String appName = 'Zadana';
  static const String appNameAr = 'زادنا';
  static const String packageName = 'com.zadana.customer';
  static const String logoLight = 'assets/images/logo_dark.png';
  static const String logoDark = 'assets/images/logo_light.png';
  static const String onboarding = 'assets/images/onboarding.png';
  static const String startPageBackground =
      'assets/images/start_page_background.png';
  static const String locationPageBackground =
      'assets/images/location_background.png';
  static const String locationImage = 'assets/images/location_image.png';
  static const String imageLocation = 'assets/images/image_location.png';

  // ── Network ──
  static const int connectTimeout = 30; // seconds
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;
  static const int maxRetries = 3;

  // ── Pagination ──
  static const int defaultPageSize = 20;
  static const int firstPage = 1;

  // ── Cache ──
  static const int cacheMaxAge = 7; // days

  // ── Input limits ──
  static const int maxNameLength = 50;
  static const int maxPhoneLength = 15;
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 32;
  static const int otpLength = 6;

  // ── Animation durations ──
  static const tabSwitchDuration = Duration(milliseconds: 300);
  static const subtitleSwitchDuration = Duration(milliseconds: 250);
  static const pillAnimationDuration = Duration(milliseconds: 300);

  // ── UI Dimensions ──
  static const double logoHeight = 52.0;
  static const double toggleHeight = 50.0;
  static const double togglePadding = 3.0;
}
