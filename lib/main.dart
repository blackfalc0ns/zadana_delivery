import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_generator.dart';
import 'package:zadana_delivery/config/theme/app_theme.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/l10n/translations/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // builder: DevicePreview.appBuilder,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [Locale('ar'), Locale('en')],
      locale: const Locale('ar'),
      theme: AppTheme.light,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: AppRoutes.driverProfileCompletion,
    );
  }
}
