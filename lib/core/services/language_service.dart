import 'dart:developer';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

@injectable
class LanguageService {
  LanguageService(this._sharedPreferences);
  final SharedPreferences _sharedPreferences;

  Future<void> saveLanguageCode(String code) async {
    await _sharedPreferences.setString(AppConstants.languageCode, code);
    log('Language saved: $code', name: 'LanguageService');
  }

  String getLanguageCode() {
    final code =
        _sharedPreferences.getString(AppConstants.languageCode) ?? 'ar';
    log('Language retrieved: $code', name: 'LanguageService');
    return code;
  }
}
