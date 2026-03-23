// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// /// ─────────────────────────────────────────────────────────────
// /// Manages app‑wide theme mode (light / dark / system).
// /// Persists user choice in Hive.
// /// ─────────────────────────────────────────────────────────────

// // ── State ──
// class ThemeState extends Equatable {
//   final ThemeMode mode;
//   const ThemeState(this.mode);

//   @override
//   List<Object?> get props => [mode];
// }

// // ── Cubit ──
// class ThemeCubit extends Cubit<ThemeState> {
//   ThemeCubit() : super(ThemeState(_loadSavedMode()));

//   static ThemeMode _loadSavedMode() {
//     final index = Preferences.getInt(StorageKeys.themeMode);
//     if (index == null) return ThemeMode.light;
//     return ThemeMode.values[index.clamp(0, ThemeMode.values.length - 1)];
//   }

//   void setThemeMode(ThemeMode mode) {
//     Preferences.setInt(StorageKeys.themeMode, mode.index);
//     emit(ThemeState(mode));
//   }

//   void toggleDarkMode() {
//     final next = state.mode == ThemeMode.dark
//         ? ThemeMode.light
//         : ThemeMode.dark;
//     setThemeMode(next);
//   }

//   bool get isDark => state.mode == ThemeMode.dark;
// }
