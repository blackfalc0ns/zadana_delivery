import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────────
/// App colour palette — all colours in ONE place.
/// Named semantically, not by colour name.
/// ─────────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  // ── Primary ──
  static const Color primary = Color(0XFF007A92);
  static const Color primaryLight = Color(0XFF007A92);
  static const Color primaryDark = Color(0XFF007A92);
  static const Color primarySurface = Color(0XFF007A92);

  // ── Secondary / Accent ──
  // static const Color secondary = Color(0xFFFFC107);
  static const Color secondary = Color(0xffe48215);
  static const Color secondaryLight = Color(0xFFFFD54F);
  static const Color secondaryDark = Color(0xFFF9A825);

  // ── Neutral (Light mode) ──
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color border = Color(0xFFDDDDDD);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // ── Neutral (Dark mode) ──
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF2C2C2C);
  static const Color dividerDark = Color(0xFF424242);

  // ── Text ──
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFF9E9E9E);
  static const Color lightGrey = Color.fromARGB(221, 227, 232, 238);

  // ── Semantic ──
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFE3F2FD);

  // ── Rating ──
  static const Color starFilled = Color(0xFFFFC107);
  static const Color starEmpty = Color(0xFFE0E0E0);

  // ── Shimmer ──
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF424242);
  static const Color shimmerHighlightDark = Color(0xFF616161);

  // ── Shadow ──
  static const Color shadow = Color(0x1A000000);
  static const Color shadowDark = Color(0x33000000);
}
