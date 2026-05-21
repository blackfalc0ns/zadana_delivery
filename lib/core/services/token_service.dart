import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

@injectable
class TokenService {
  TokenService({
    required FlutterSecureStorage prefs,
    required SharedPreferences sharedPreferences,
  }) : _prefs = prefs,
       _sharedPreferences = sharedPreferences;

  static const String _nativePrefsAccessTokenKey = 'accessToken';
  static const String _nativePrefsRefreshTokenKey = 'refreshToken';
  final FlutterSecureStorage _prefs;
  final SharedPreferences _sharedPreferences;
  // ---------------- ACCESS TOKEN ----------------

  bool get isAccessTokenSaved =>
      _sharedPreferences.getBool(AppConstants.isAccessTokenSaved) ?? false;

  Future<void> saveAccessToken(String token) async {
    await _sharedPreferences.setBool(AppConstants.isAccessTokenSaved, true);
    await _sharedPreferences.setString(_nativePrefsAccessTokenKey, token);
    await _prefs.write(key: AppConstants.accessToken, value: token);
  }

  Future<String?> getToken() async {
    if (!isAccessTokenSaved) return null;
    return _prefs.read(key: AppConstants.accessToken);
  }

  Future<void> deleteToken() async {
    await _sharedPreferences.setBool(AppConstants.isAccessTokenSaved, false);
    await _sharedPreferences.remove(_nativePrefsAccessTokenKey);
    await _prefs.delete(key: AppConstants.accessToken);
  }

  // ---------------- REFRESH TOKEN ----------------

  bool get isRefreshTokenSaved =>
      _sharedPreferences.getBool(AppConstants.isRefreshTokenSaved) ?? false;

  Future<void> saveRefreshToken(String token) async {
    await _sharedPreferences.setBool(AppConstants.isRefreshTokenSaved, true);
    await _sharedPreferences.setString(_nativePrefsRefreshTokenKey, token);
    await _prefs.write(key: AppConstants.refreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    if (!isRefreshTokenSaved) return null;
    return _prefs.read(key: AppConstants.refreshToken);
  }

  Future<void> deleteRefreshToken() async {
    await _sharedPreferences.setBool(AppConstants.isRefreshTokenSaved, false);
    await _sharedPreferences.remove(_nativePrefsRefreshTokenKey);
    await _prefs.delete(key: AppConstants.refreshToken);
  }

  Future<void> syncNativeTokenMirror() async {
    final accessToken = await _prefs.read(key: AppConstants.accessToken);
    final refreshToken = await _prefs.read(key: AppConstants.refreshToken);

    if ((accessToken ?? '').trim().isNotEmpty) {
      await _sharedPreferences.setBool(AppConstants.isAccessTokenSaved, true);
      await _sharedPreferences.setString(
        _nativePrefsAccessTokenKey,
        accessToken!.trim(),
      );
    } else {
      await _sharedPreferences.setBool(AppConstants.isAccessTokenSaved, false);
      await _sharedPreferences.remove(_nativePrefsAccessTokenKey);
    }

    if ((refreshToken ?? '').trim().isNotEmpty) {
      await _sharedPreferences.setBool(AppConstants.isRefreshTokenSaved, true);
      await _sharedPreferences.setString(
        _nativePrefsRefreshTokenKey,
        refreshToken!.trim(),
      );
    } else {
      await _sharedPreferences.setBool(AppConstants.isRefreshTokenSaved, false);
      await _sharedPreferences.remove(_nativePrefsRefreshTokenKey);
    }
  }

  Future<void> clearTokens() async {
    await deleteToken();
    await deleteRefreshToken();
    await deleteCurrentUserId();
  }

  Future<void> saveCurrentUserId(String userId) async {
    final normalizedUserId = userId.trim();
    if (normalizedUserId.isEmpty) return;
    await _sharedPreferences.setString(
      AppConstants.currentUserId,
      normalizedUserId,
    );
  }

  Future<String?> getCurrentUserId() async {
    final value = _sharedPreferences.getString(AppConstants.currentUserId);
    final normalizedValue = value?.trim() ?? '';
    return normalizedValue.isEmpty ? null : normalizedValue;
  }

  Future<void> deleteCurrentUserId() async {
    await _sharedPreferences.remove(AppConstants.currentUserId);
  }
}
