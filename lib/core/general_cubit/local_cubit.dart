import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/general_cubit/general_state.dart';
import 'package:zadana_delivery/core/services/language_service.dart';
import 'package:zadana_delivery/core/utils/constants.dart';

class LocaleCubit extends ChangeNotifier {
  LocaleCubit(this._languageService)
    : _state = LocaleThemeState(
        locale: Locale(_languageService.getLanguageCode()),
        isDark: false,
      );

  final LanguageService _languageService;
  LocaleThemeState _state;

  LocaleThemeState get state => _state;
  Locale get locale => _state.locale;

  Future<void> setLocale(String languageCode) async {
    if (_state.locale.languageCode == languageCode) return;
    await _languageService.saveLanguageCode(languageCode);
    _state = _state.copyWith(locale: Locale(languageCode));
    notifyListeners();
  }

  Future<void> setArabic() => setLocale(AppConstants.arKey);

  Future<void> setEnglish() => setLocale(AppConstants.enKey);
}

class LocaleCubitScope extends InheritedNotifier<LocaleCubit> {
  const LocaleCubitScope({
    super.key,
    required LocaleCubit cubit,
    required super.child,
  }) : super(notifier: cubit);

  static LocaleCubit of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<LocaleCubitScope>();
    assert(scope != null, 'LocaleCubitScope not found in context');
    return scope!.notifier!;
  }

  static LocaleCubit? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<LocaleCubitScope>()
        ?.notifier;
  }
}
