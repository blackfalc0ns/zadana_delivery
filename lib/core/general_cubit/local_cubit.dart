// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:injectable/injectable.dart';
// import '../di/di.dart';
// import '../helpers/shared_pref.dart';
// import '../utils/constants.dart';

// @injectable
// class LocaleThemeCubit extends Cubit<LocaleThemeState> {
//   LocaleThemeCubit()
//       : super(
//           LocaleThemeState(
//             locale: Locale(
//               getIt<SharedPrefHelper>()
//                       .getData(key: AppConstants.languageCode) as String? ??
//                   AppConstants.enKey,
//             ),
//             isDark: getIt<SharedPrefHelper>()
//                     .getData(key: AppConstants.isDark) as bool? ??
//                 false,
//           ),
//         );

//   void changeLocale() {
//     final lanCode = state.locale.languageCode;
//     if (lanCode == AppConstants.enKey) {
//       getIt<SharedPrefHelper>()
//           .saveData(key: AppConstants.languageCode, val: AppConstants.arKey);
//       emit(state.copyWith(locale: const Locale(AppConstants.arKey)));
//     } else {
//       getIt<SharedPrefHelper>()
//           .saveData(key: AppConstants.languageCode, val: AppConstants.enKey);
//       emit(state.copyWith(locale: const Locale(AppConstants.enKey)));
//     }
//   }

//   void toggleTheme() {
//     final newTheme = !state.isDark;
//     getIt<SharedPrefHelper>()
//         .saveData(key: AppConstants.isDark, val: newTheme);
//     emit(state.copyWith(isDark: newTheme));
//   }
// }
