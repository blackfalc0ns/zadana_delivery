import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/features/app_shell/presentation/screens/app_shell_screen.dart';
import 'package:zadana_delivery/features/auth/presentation/screens/account_pending_approval_screen.dart';
import 'package:zadana_delivery/features/auth/presentation/screens/auth_gate_screen.dart';
import 'package:zadana_delivery/features/auth/presentation/screens/driver_profile_completion_screen.dart';
import 'package:zadana_delivery/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:zadana_delivery/features/auth/presentation/screens/login_screen.dart';
import 'package:zadana_delivery/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:zadana_delivery/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/screens/completed_orders_screen.dart';
import 'package:zadana_delivery/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:zadana_delivery/features/order_details/presentation/screens/order_details_screen.dart';
import 'package:zadana_delivery/features/wallet/presentation/screens/wallet_screen.dart';

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
      case AppRoutes.accountPendingApproval:
        return MaterialPageRoute(
          builder: (_) => const AccountPendingApprovalScreen(),
        );
      case AppRoutes.driverHome:
      case AppRoutes.mainShell:
        return MaterialPageRoute(builder: (_) => const AppShellScreen());
      case AppRoutes.completedOrders:
        return MaterialPageRoute(builder: (_) => const CompletedOrdersScreen());
      case AppRoutes.wallet:
        return MaterialPageRoute(builder: (_) => const WalletScreen());
      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case AppRoutes.orderDetails:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OrderDetailsScreen(
            order: args['order'],
            driverLocation: args['driverLocation'],
          ),
        );
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


