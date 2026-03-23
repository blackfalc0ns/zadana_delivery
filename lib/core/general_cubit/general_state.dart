import 'package:flutter/material.dart';

class LocaleThemeState {
  final Locale locale;
  final bool isDark;

  LocaleThemeState({required this.locale, required this.isDark});

  LocaleThemeState copyWith({Locale? locale, bool? isDark}) {
    return LocaleThemeState(
      locale: locale ?? this.locale,
      isDark: isDark ?? this.isDark,
    );
  }
}