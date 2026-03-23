/// ─────────────────────────────────────────────────────────────
/// Standardised durations used app‑wide for animations,
/// debouncing, and timeouts.
///
/// Named [AppDurations] to avoid conflict with Flutter's
/// built-in [Durations] class.
/// ─────────────────────────────────────────────────────────────
class AppDurations {
  AppDurations._();

  // ── Animations ──
  static const Duration fastest = Duration(milliseconds: 150);
  static const Duration fast = Duration(milliseconds: 250);
  static const Duration normal = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration slower = Duration(milliseconds: 700);
  static const Duration slowest = Duration(milliseconds: 1000);

  // ── Page transitions ──
  static const Duration pageTransition = Duration(milliseconds: 300);

  // ── Debounce / Throttle ──
  static const Duration debounce = Duration(milliseconds: 400);
  static const Duration throttle = Duration(milliseconds: 1000);

  // ── Snackbar / Toast ──
  static const Duration snackbar = Duration(seconds: 3);
  static const Duration toast = Duration(seconds: 2);

  // ── Splash ──
  static const Duration splash = Duration(seconds: 2);

  // ── Network ──
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
