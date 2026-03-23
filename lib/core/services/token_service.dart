import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

@injectable
class TokenService {
  final FlutterSecureStorage _prefs;
  final SharedPreferences _sharedPreferences;

  TokenService({
    required FlutterSecureStorage prefs,
    required SharedPreferences sharedPreferences,
  }) : _prefs = prefs,
       _sharedPreferences = sharedPreferences;
  // ---------------- ACCESS TOKEN ----------------

  bool get isAccessTokenSaved =>
      _sharedPreferences.getBool(AppConstants.isAccessTokenSaved) ?? false;

  Future<void> saveAccessToken(String token) async {
    await _sharedPreferences.setBool(AppConstants.isAccessTokenSaved, true);
    await _prefs.write(key: AppConstants.accessToken, value: token);
  }

  Future<String?> getToken() async {
    if (!isAccessTokenSaved) return null;
    return _prefs.read(key: AppConstants.accessToken);
  }

  Future<void> deleteToken() async {
    await _sharedPreferences.setBool(AppConstants.isAccessTokenSaved, false);
    await _prefs.delete(key: AppConstants.accessToken);
  }


  // ---------------- REFRESH TOKEN ----------------

   bool get isRefreshTokenSaved =>
      _sharedPreferences.getBool(AppConstants.isRefreshTokenSaved) ?? false;

  Future<void> saveRefreshToken(String token) async {
    await _sharedPreferences.setBool(AppConstants.isRefreshTokenSaved, true);
    await _prefs.write(key: AppConstants.refreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    if (!isRefreshTokenSaved) return null;
    return _prefs.read(key: AppConstants.refreshToken);
  }

  Future<void> deleteRefreshToken() async {
    await _sharedPreferences.setBool(AppConstants.isRefreshTokenSaved, false);
    await _prefs.delete(key: AppConstants.refreshToken);
  }
}
