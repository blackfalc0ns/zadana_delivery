import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_generator.dart';
import 'package:zadana_delivery/config/theme/app_theme.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/general_cubit/local_cubit.dart';
import 'package:zadana_delivery/core/l10n/translations/app_localizations.dart';
import 'package:zadana_delivery/core/services/language_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(DevicePreview(builder: (context) => const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final LocaleCubit _localeCubit;

  @override
  void initState() {
    super.initState();
    _localeCubit = LocaleCubit(getIt<LanguageService>());
  }

  @override
  void dispose() {
    _localeCubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LocaleCubitScope(
      cubit: _localeCubit,
      child: AnimatedBuilder(
        animation: _localeCubit,
        builder: (context, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
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
