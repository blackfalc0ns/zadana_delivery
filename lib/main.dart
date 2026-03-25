import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_generator.dart';
import 'package:zadana_delivery/config/theme/app_theme.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/l10n/translations/app_localizations.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp( DevicePreview(
    enabled: true,
    builder: (context) => MyApp(), 
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
     // locale: DevicePreview.locale(context),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      theme: AppTheme.light,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: AppRoutes.mainShell,
    );
  }
}