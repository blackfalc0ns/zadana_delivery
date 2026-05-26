import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/core/services/app_navigator_service.dart';
import 'package:zadana_delivery/core/services/driver_realtime_service.dart';
import 'package:zadana_delivery/core/services/token_service.dart';

/// Centralized handler for session expiry events (token revocation,
/// refresh failure, etc.). Ensures the user is navigated to the login
/// screen exactly once, even if multiple sources detect the expiry
/// simultaneously.
@lazySingleton
class SessionExpiryHandler {
  SessionExpiryHandler({
    required TokenService tokenService,
    required AppNavigatorService navigatorService,
    required DriverRealtimeService realtimeService,
  })  : _tokenService = tokenService,
        _navigatorService = navigatorService,
        _realtimeService = realtimeService;

  final TokenService _tokenService;
  final AppNavigatorService _navigatorService;
  final DriverRealtimeService _realtimeService;

  bool _isHandling = false;

  /// Call this when a 401 with revocation/expiry is detected.
  /// Safe to call multiple times — only the first call takes effect.
  Future<void> handleSessionExpired() async {
    if (_isHandling) return;
    _isHandling = true;

    debugPrint('[SessionExpiry] Session expired, navigating to login');

    try {
      await _tokenService.clearTokens();
      await _realtimeService.disconnect();
      await _navigatorService.resetToNamedWhenReady(AppRoutes.login);
    } catch (e) {
      debugPrint('[SessionExpiry] Error during session expiry handling: $e');
    } finally {
      // Allow future expiry handling (e.g. if user logs in again and
      // the new session also expires).
      _isHandling = false;
    }
  }
}
