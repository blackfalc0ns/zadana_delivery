import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_generator.dart';
import 'package:zadana_delivery/config/theme/app_theme.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/general_cubit/local_cubit.dart';
import 'package:zadana_delivery/core/l10n/translations/app_localizations.dart';
import 'package:zadana_delivery/core/services/app_navigator_service.dart';
import 'package:zadana_delivery/core/services/driver_notification_bootstrap_service.dart';
import 'package:zadana_delivery/core/services/driver_notification_overlay_service.dart';
import 'package:zadana_delivery/core/services/driver_notification_session_service.dart';
import 'package:zadana_delivery/core/services/driver_realtime_service.dart';
import 'package:zadana_delivery/core/services/language_service.dart';

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
  late final LocaleCubit _localeCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _localeCubit = LocaleCubit(getIt<LanguageService>());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<AppNavigatorService>().markReady();
      getIt<DriverNotificationOverlayService>().startListening();
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
    unawaited(getIt<DriverRealtimeService>().handleAppLifecycleState(state));
  }

  Future<void> _bootstrapNotificationServicesAfterUiReady() async {
    await getIt<DriverNotificationBootstrapService>().initialize();
    await getIt<DriverNotificationSessionService>()
        .restoreAuthenticatedSessionIfPossible();
    await getIt<DriverNotificationBootstrapService>()
        .requestNotificationPermissionAfterUiReady();
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
