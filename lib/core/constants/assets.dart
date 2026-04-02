/// ─────────────────────────────────────────────────────────────
/// Centralised asset paths — autocomplete‑friendly, typo‑proof.
/// ─────────────────────────────────────────────────────────────
class Assets {
  Assets._();

  // ── Base paths ──
  static const String _images = 'assets/images';
  static const String _icons = 'assets/icons';
  static const String _fonts = 'assets/fonts';

  // ── Images ──
  static const String logoDark = '$_images/logo_dark.png';
  static const String logoLight = '$_images/logo_light.png';
  static const String placeholder = '$_images/placeholder.png';
  static const String noInternet = '$_images/no_internet.png';
  static const String empty = '$_images/empty.png';
  static const String error = '$_images/error.png';
  static const String onboarding1 = '$_images/onboarding1.png';
  static const String onboarding2 = '$_images/onboarding2.png';
  static const String onboarding3 = '$_images/onboarding3.png';
  static const String goole = '$_images/google_icon.png';

  // ── Icons (SVG) ──
  static const String icHome = '$_icons/ic_home.svg';
  static const String icProfile = '$_icons/ic_profile.svg';
  static const String icSettings = '$_icons/ic_settings.svg';
  static const String icNotification = '$_icons/ic_notification.svg';
  static const String icSearch = '$_icons/ic_search.svg';
  static const String icBack = '$_icons/ic_back.svg';
  static const String icClose = '$_icons/ic_close.svg';
  static const String icMenu = '$_icons/ic_menu.svg';
  static const String icLocation = '$_icons/ic_location.svg';
  static const String icWallet = '$_icons/ic_wallet.svg';

  // ── Search Icon ──
  static const String searchNormal = '$_images/search-normal.svg';

  // ── Fonts ──
  static const String cairoRegular = '$_fonts/Cairo-Regular.ttf';
  static const String cairoMedium = '$_fonts/Cairo-Medium.ttf';
  static const String cairoSemiBold = '$_fonts/Cairo-SemiBold.ttf';
  static const String cairoBold = '$_fonts/Cairo-Bold.ttf';
}
