import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';

class WalletThemeExtension extends ThemeExtension<WalletThemeExtension> {
  const WalletThemeExtension({
    required this.heroGradient,
    required this.heroGlow,
    required this.successTint,
    required this.warningTint,
    required this.infoTint,
    required this.bonusTint,
    required this.alertTint,
    required this.softBorder,
    required this.cardShadow,
  });

  final Gradient heroGradient;
  final Color heroGlow;
  final Color successTint;
  final Color warningTint;
  final Color infoTint;
  final Color bonusTint;
  final Color alertTint;
  final Color softBorder;
  final List<BoxShadow> cardShadow;

  static const WalletThemeExtension light = WalletThemeExtension(
    heroGradient: LinearGradient(
      colors: [Color(0xFF0B8FA3), Color(0xFF05657D), Color(0xFF02384E)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    heroGlow: Color(0x332BBBD0),
    successTint: AppColors.success,
    warningTint: AppColors.warning,
    infoTint: AppColors.info,
    bonusTint: AppColors.secondary,
    alertTint: AppColors.primary,
    softBorder: Color(0xFFE5ECF1),
    cardShadow: [
      BoxShadow(
        color: Color(0x140E2233),
        blurRadius: 24,
        offset: Offset(0, 14),
        spreadRadius: -10,
      ),
    ],
  );

  static const WalletThemeExtension dark = WalletThemeExtension(
    heroGradient: LinearGradient(
      colors: [Color(0xFF0E6173), Color(0xFF0A4152), Color(0xFF091E2A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    heroGlow: Color(0x1A63D7E8),
    successTint: Color(0xFF62D184),
    warningTint: Color(0xFFFFB84D),
    infoTint: Color(0xFF64B5FF),
    bonusTint: Color(0xFFFFB35C),
    alertTint: Color(0xFF5CC7D7),
    softBorder: Color(0xFF24323D),
    cardShadow: [
      BoxShadow(
        color: Color(0x33000000),
        blurRadius: 28,
        offset: Offset(0, 16),
        spreadRadius: -12,
      ),
    ],
  );

  @override
  WalletThemeExtension copyWith({
    Gradient? heroGradient,
    Color? heroGlow,
    Color? successTint,
    Color? warningTint,
    Color? infoTint,
    Color? bonusTint,
    Color? alertTint,
    Color? softBorder,
    List<BoxShadow>? cardShadow,
  }) {
    return WalletThemeExtension(
      heroGradient: heroGradient ?? this.heroGradient,
      heroGlow: heroGlow ?? this.heroGlow,
      successTint: successTint ?? this.successTint,
      warningTint: warningTint ?? this.warningTint,
      infoTint: infoTint ?? this.infoTint,
      bonusTint: bonusTint ?? this.bonusTint,
      alertTint: alertTint ?? this.alertTint,
      softBorder: softBorder ?? this.softBorder,
      cardShadow: cardShadow ?? this.cardShadow,
    );
  }

  @override
  ThemeExtension<WalletThemeExtension> lerp(
    covariant ThemeExtension<WalletThemeExtension>? other,
    double t,
  ) {
    if (other is! WalletThemeExtension) {
      return this;
    }

    return WalletThemeExtension(
      heroGradient: Gradient.lerp(heroGradient, other.heroGradient, t)!,
      heroGlow: Color.lerp(heroGlow, other.heroGlow, t)!,
      successTint: Color.lerp(successTint, other.successTint, t)!,
      warningTint: Color.lerp(warningTint, other.warningTint, t)!,
      infoTint: Color.lerp(infoTint, other.infoTint, t)!,
      bonusTint: Color.lerp(bonusTint, other.bonusTint, t)!,
      alertTint: Color.lerp(alertTint, other.alertTint, t)!,
      softBorder: Color.lerp(softBorder, other.softBorder, t)!,
      cardShadow: t < 0.5 ? cardShadow : other.cardShadow,
    );
  }
}
