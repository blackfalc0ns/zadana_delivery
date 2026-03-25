/// ─────────────────────────────────────────────────────────────
/// Consistent spacing & sizing tokens used across the app.
/// ─────────────────────────────────────────────────────────────
class Spacing {
  Spacing._();

  // ── Base unit (4 dp grid) ──
  static const double unit = 4.0;

  // ── Named sizes ──
  static const double xs = 4.0; // unit × 1
  static const double xss = 6.0; // unit × 1.5
  static const double sm = 8.0; // unit × 2
  static const double md = 12.0; // unit × 3
  static const double base = 16.0; // unit × 4  (default)
  static const double lg = 20.0; // unit × 5
  static const double xl = 24.0; // unit × 6
  static const double xxl = 32.0; // unit × 8
  static const double xxxl = 48.0; // unit × 12

  // ── Screen padding ──
  static const double screenH =8.0; // Horizontal (reduced from 8.0)
  static const double screenV = 16.0; // Vertical

  // ── Card ──
  static const double cardPadding = 16.0;
  static const double cardRadius = 12.0;
  static const double cardElevation = 2.0;

  // ── Button ──
  static const double buttonHeight = 48.0;
  static const double buttonSmallHeight = 40.0;
  static const double buttonRadius = 12.0;
  static const double buttonSmallRadius = 8.0;

  // ── Input field ──
  static const double inputHeight = 48.0;
  static const double inputRadius = 12.0;

  // ── Bottom sheet ──
  static const double bottomSheetRadius = 24.0;

  // ── App bar ──
  static const double appBarHeight = 56.0;

  // ── Bottom nav ──
  static const double bottomNavHeight = 65.0;

  // ── Avatar ──
  static const double avatarSm = 32.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 72.0;

  // ── Icon ──
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;
}
