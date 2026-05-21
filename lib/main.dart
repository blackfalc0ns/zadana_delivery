import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_generator.dart';
import 'package:zadana_delivery/config/theme/app_theme.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/general_cubit/local_cubit.dart';
import 'package:zadana_delivery/core/l10n/translations/app_localizations.dart';
import 'package:zadana_delivery/core/network/network_constants.dart';
import 'package:zadana_delivery/core/services/app_navigator_service.dart';
import 'package:zadana_delivery/core/services/driver_notification_bootstrap_service.dart';
import 'package:zadana_delivery/core/services/driver_notification_overlay_service.dart';
import 'package:zadana_delivery/core/services/driver_notification_session_service.dart';
import 'package:zadana_delivery/core/services/driver_realtime_service.dart';
import 'package:zadana_delivery/core/services/language_service.dart';
import 'package:zadana_delivery/core/services/token_service.dart';
import 'package:zadana_delivery/core/services/trip_request_global_alert_service.dart';
import 'package:zadana_delivery/features/driver_home/data/data_source/driver_home_remote_data_source.dart';
import 'package:zadana_delivery/features/driver_tracking/domain/repo/driver_tracking_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(
    DevicePreview(
      // ignore: avoid_redundant_argument_values
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static const Duration _notificationBootstrapDelay = Duration(
    milliseconds: 250,
  );
  static const Duration _sessionRestoreDelay = Duration(milliseconds: 900);
  static const Duration _permissionPromptDelay = Duration(milliseconds: 1600);

  late final LocaleCubit _localeCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _localeCubit = LocaleCubit(getIt<LanguageService>());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<AppNavigatorService>().markReady();
      getIt<DriverNotificationOverlayService>().startListening();
      getIt<TripRequestGlobalAlertService>().startListening();
      unawaited(getIt<TokenService>().syncNativeTokenMirror());
      unawaited(_bootstrapNotificationServicesAfterUiReady());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _localeCubit.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(getIt<DriverTrackingRepository>().syncAppLifecycleState(true));
      // Schedule resume work after a short delay to let the UI thread settle
      // and avoid ANR from parallel DNS lookups + SignalR reconnections.
      Future<void>.delayed(
        const Duration(milliseconds: 600),
        _handleAppResumed,
      );
    } else {
      if (state == AppLifecycleState.inactive ||
          state == AppLifecycleState.hidden ||
          state == AppLifecycleState.paused ||
          state == AppLifecycleState.detached) {
        unawaited(
          getIt<DriverTrackingRepository>().syncAppLifecycleState(false),
        );
      }
      unawaited(getIt<DriverRealtimeService>().handleAppLifecycleState(state));
    }
  }

  Future<void> _handleAppResumed() async {
    // Fire-and-forget: reconnect in the background to avoid blocking the UI.
    unawaited(
      Future<void>(() async {
        await getIt<DriverRealtimeService>().ensureConnected();
        final homeDataSource = getIt<DriverHomeRemoteDataSource>();
        await homeDataSource.ensureRealtimeConnected();
      }),
    );
    // Check if a delivery-offer push arrived while Flutter was detached.
    try {
      const channel = MethodChannel(
        NetworkConstants.nativeNotificationsChannel,
      );
      final timestamp =
          await channel.invokeMethod<int>('consumeOfferPushTimestamp') ?? 0;
      if (timestamp > 0) {
        final age = DateTime.now().millisecondsSinceEpoch - timestamp;
        // Only act on it if it arrived within the last 2 minutes.
        if (age < 120000) {
          final homeDataSource = getIt<DriverHomeRemoteDataSource>();
          unawaited(homeDataSource.notifyOfferPushReceived());
        }
      }
    } catch (_) {}
  }

  Future<void> _bootstrapNotificationServicesAfterUiReady() async {
    await Future<void>.delayed(_notificationBootstrapDelay);

    try {
      await getIt<DriverNotificationBootstrapService>().initialize();
    } catch (_) {
      return;
    }

    unawaited(_restoreNotificationSessionInBackground());
    unawaited(_requestNotificationPermissionInBackground());
  }

  Future<void> _restoreNotificationSessionInBackground() async {
    await Future<void>.delayed(_sessionRestoreDelay);
    try {
      await getIt<DriverNotificationSessionService>()
          .restoreAuthenticatedSessionIfPossible();
    } catch (_) {}
  }

  Future<void> _requestNotificationPermissionInBackground() async {
    await Future<void>.delayed(_permissionPromptDelay);
    try {
      await getIt<DriverNotificationBootstrapService>()
          .requestNotificationPermissionAfterUiReady();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return LocaleCubitScope(
      cubit: _localeCubit,
      child: AnimatedBuilder(
        animation: _localeCubit,
        builder: (context, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: getIt<AppNavigatorService>().navigatorKey,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: const [Locale('ar'), Locale('en')],
          locale: _localeCubit.locale,
          theme: AppTheme.light,
          onGenerateRoute: RouteGenerator.getRoute,
          initialRoute: AppRoutes.authGate,
        ),
      ),
    );
  }
}
