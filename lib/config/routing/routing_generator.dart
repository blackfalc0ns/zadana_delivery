import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/features/app_shell/presentation/screens/app_shell_screen.dart';
import 'package:zadana_delivery/features/auth/presentation/screens/auth_gate_screen.dart';
import 'package:zadana_delivery/features/auth/presentation/screens/driver_profile_completion_screen.dart';
import 'package:zadana_delivery/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:zadana_delivery/features/auth/presentation/screens/login_screen.dart';
import 'package:zadana_delivery/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:zadana_delivery/features/auth/presentation/screens/sign_up_screen.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.authGate:
        return MaterialPageRoute(builder: (_) => const AuthGateScreen());
      case AppRoutes.login:
        final initialIdentifier = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => LoginScreen(initialIdentifier: initialIdentifier),
        );
      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case AppRoutes.forgetPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case AppRoutes.resetPassword:
        final identifier = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(identifier: identifier),
        );
      case AppRoutes.driverProfileCompletion:
        return MaterialPageRoute(
          builder: (_) => const DriverProfileCompletionScreen(),
        );
      case AppRoutes.driverHome:
      case AppRoutes.mainShell:
        return MaterialPageRoute(builder: (_) => const AppShellScreen());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('No Route Found')),
        body: const Center(child: Text('No Route Found')),
      ),
    );
  }
}
