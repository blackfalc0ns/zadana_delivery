import 'package:zadana_delivery/core/constants/assets.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'Zadana';
  static const String appNameAr = 'زادنا';
  static const String packageName = 'com.zadana.customer';
  static const String logoLight = Assets.logoDark;
  static const String logoDark = Assets.logoLight;
  static const String onboarding = Assets.onboarding;
  static const String startPageBackground = Assets.startPageBackground;
  static const String locationPageBackground = Assets.locationBackground;
  static const String locationImage = Assets.locationImage;
  static const String imageLocation = Assets.imageLocation;

  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;
  static const int maxRetries = 3;

  static const int defaultPageSize = 20;
  static const int firstPage = 1;

  static const int cacheMaxAge = 7;

  static const int maxNameLength = 50;
  static const int maxPhoneLength = 15;
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 32;
  static const int otpLength = 6;

  static const tabSwitchDuration = Duration(milliseconds: 300);
  static const subtitleSwitchDuration = Duration(milliseconds: 250);
  static const pillAnimationDuration = Duration(milliseconds: 300);

  static const double logoHeight = 52.0;
  static const double toggleHeight = 50.0;
  static const double togglePadding = 3.0;

  // Trip overlay system preferences
  static const String tripOverlayEnabledKey = 'trip_overlay_enabled';
}
