import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppNavigatorService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final Completer<void> _readyCompleter = Completer<void>();

  static const Duration _retryDelay = Duration(milliseconds: 150);
  static const int _retryAttempts = 40;

  BuildContext? get currentContext => navigatorKey.currentContext;

  NavigatorState? get navigator => navigatorKey.currentState;

  bool get isReady => _readyCompleter.isCompleted || navigator != null;

  void markReady() {
    if (!_readyCompleter.isCompleted) {
      _readyCompleter.complete();
    }
  }

  Future<void> waitUntilReady() async {
    if (!_readyCompleter.isCompleted && navigator != null) {
      _readyCompleter.complete();
    }

    await _readyCompleter.future;

    for (var attempt = 0; attempt < _retryAttempts; attempt++) {
      if (navigator != null) {
        return;
      }
      await WidgetsBinding.instance.endOfFrame;
      await Future<void>.delayed(_retryDelay);
    }
  }

  Future<T?> pushNamedWhenReady<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    await waitUntilReady();
    return navigator?.pushNamed<T>(routeName, arguments: arguments);
  }

  Future<T?> pushReplacementNamedWhenReady<
    T extends Object?,
    TO extends Object?
  >(String routeName, {Object? arguments, TO? result}) async {
    await waitUntilReady();
    return navigator?.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  Future<T?> resetToNamedWhenReady<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    await waitUntilReady();
    return navigator?.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }
}
