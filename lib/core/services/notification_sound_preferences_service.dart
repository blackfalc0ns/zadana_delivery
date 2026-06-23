import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zadana_delivery/core/utils/constants.dart';

/// Valid notification sound values accepted by the API.
abstract class NotificationSoundValues {
  static const String classic = 'classic';
  static const String chime = 'chime';
  static const String soft = 'soft';
  static const String urgent = 'urgent';
  static const String off = 'off';

  static const List<String> all = [classic, chime, soft, urgent, off];

  /// Returns [value] if valid, otherwise returns [classic] as fallback.
  static String validate(String? value) {
    if (value == null || value.trim().isEmpty) return classic;
    final normalized = value.trim().toLowerCase();
    return all.contains(normalized) ? normalized : classic;
  }
}

/// Mobile notification categories (not admin categories).
abstract class NotificationSoundCategories {
  static const String defaultCategory = 'default';
  static const String dispatch = 'dispatch';
  static const String assignment = 'assignment';
  static const String support = 'support';
  static const String wallet = 'wallet';
  static const String account = 'account';

  static const List<String> all = [
    defaultCategory,
    dispatch,
    assignment,
    support,
    wallet,
    account,
  ];

  /// Mobile-only categories (used in the settings UI — excludes "default").
  static const List<String> mobile = [
    dispatch,
    assignment,
    support,
    wallet,
    account,
  ];
}

/// Maps notification sound keys to local asset paths.
const Map<String, String?> soundAssets = {
  'classic': 'assets/sounds/classic.wav',
  'chime': 'assets/sounds/chime.wav',
  'soft': 'assets/sounds/soft.wav',
  'urgent': 'assets/sounds/urgent.wav',
  'off': null,
};

/// Manages local caching and resolution of per-category notification sounds.
@lazySingleton
class NotificationSoundPreferencesService {
  NotificationSoundPreferencesService(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  /// Cached in-memory copy of the per-category sounds map.
  Map<String, String>? _cachedSounds;

  /// Returns the locally-cached notification sounds map.
  /// Keys are categories (default, dispatch, assignment, support, wallet, account).
  /// Values are sound keys (classic, chime, soft, urgent, off).
  Map<String, String> getSoundsMap() {
    if (_cachedSounds != null) return Map.unmodifiable(_cachedSounds!);

    final raw = _sharedPreferences.getString(AppConstants.notificationSoundsMap);
    if (raw != null && raw.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          _cachedSounds = Map<String, String>.from(
            decoded.map((key, value) => MapEntry(
              key.toString(),
              NotificationSoundValues.validate(value?.toString()),
            )),
          );
          return Map.unmodifiable(_cachedSounds!);
        }
      } catch (_) {}
    }

    _cachedSounds = const {};
    return const {};
  }

  /// Persists the sounds map from a server response's `notificationSounds` field.
  Future<void> syncFromServerResponse(Map<String, dynamic>? serverSounds) async {
    if (serverSounds == null || serverSounds.isEmpty) return;

    final validated = <String, String>{};
    for (final entry in serverSounds.entries) {
      final key = entry.key.toString().trim().toLowerCase();
      if (NotificationSoundCategories.all.contains(key)) {
        validated[key] = NotificationSoundValues.validate(entry.value?.toString());
      }
    }

    _cachedSounds = validated;
    await _sharedPreferences.setString(
      AppConstants.notificationSoundsMap,
      jsonEncode(validated),
    );
    debugPrint(
      '[NotificationSoundPreferences] Synced sounds map from server: $validated',
    );
  }

  /// Resolves the sound key for a given notification category.
  ///
  /// Priority:
  /// 1. Local map for [category]
  /// 2. [dataSound] hint from push payload
  /// 3. Local map 'default'
  /// 4. Fallback to 'classic'
  String resolveSound({
    String? category,
    String? dataSound,
  }) {
    final sounds = getSoundsMap();

    // 1. Check per-category sound
    if (category != null && category.trim().isNotEmpty) {
      final categoryKey = category.trim().toLowerCase();
      final categorySound = sounds[categoryKey];
      if (categorySound != null && categorySound.isNotEmpty) {
        return NotificationSoundValues.validate(categorySound);
      }
    }

    // 2. Check data hint from server
    if (dataSound != null && dataSound.trim().isNotEmpty) {
      return NotificationSoundValues.validate(dataSound);
    }

    // 3. Check default
    final defaultSound = sounds[NotificationSoundCategories.defaultCategory];
    if (defaultSound != null && defaultSound.isNotEmpty) {
      return NotificationSoundValues.validate(defaultSound);
    }

    // 4. Fallback
    return NotificationSoundValues.classic;
  }

  /// Returns the asset path for the resolved sound key, or null if 'off'.
  String? resolveSoundAssetPath({
    String? category,
    String? dataSound,
  }) {
    final soundKey = resolveSound(category: category, dataSound: dataSound);
    return soundAssets[soundKey];
  }

  /// Returns the sound for a specific category only (no fallback chain).
  String getSoundForCategory(String category) {
    final sounds = getSoundsMap();
    return NotificationSoundValues.validate(sounds[category.toLowerCase()]);
  }

  /// Builds the `notificationSounds` body for PUT preferences API.
  Map<String, String> buildApiBody(Map<String, String> updatedSounds) {
    final body = <String, String>{};
    for (final entry in updatedSounds.entries) {
      final key = entry.key.trim().toLowerCase();
      if (NotificationSoundCategories.all.contains(key)) {
        body[key] = NotificationSoundValues.validate(entry.value);
      }
    }
    return body;
  }
}
