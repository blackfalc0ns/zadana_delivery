import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/features/app_shell/presentation/screens/app_shell_screen.dart';
import 'package:zadana_delivery/features/auth/account_status/domain/entities/driver_account_status_entity.dart';
import 'package:zadana_delivery/features/auth/forgot_password/presentation/pages/forgot_password_screen.dart';
import 'package:zadana_delivery/features/auth/login/presentation/pages/login_screen.dart';
import 'package:zadana_delivery/features/auth/register/presentation/models/register_account_draft.dart';
import 'package:zadana_delivery/features/auth/register/presentation/pages/driver_profile_completion_screen.dart';
import 'package:zadana_delivery/features/auth/register/presentation/pages/sign_up_screen.dart';
import 'package:zadana_delivery/features/auth/reset_password/presentation/pages/reset_password_screen.dart';
import 'package:zadana_delivery/features/auth/session/presentation/pages/account_blocked_screen.dart';
import 'package:zadana_delivery/features/auth/session/presentation/pages/account_pending_approval_screen.dart';
import 'package:zadana_delivery/features/auth/session/presentation/pages/auth_gate_screen.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_entity.dart';
import 'package:zadana_delivery/features/driver_support/presentation/screens/driver_support_case_detail_entry_screen.dart';
import 'package:zadana_delivery/features/driver_support/presentation/screens/driver_support_case_details_screen.dart';
import 'package:zadana_delivery/features/driver_support/presentation/screens/driver_support_cases_screen.dart';
import 'package:zadana_delivery/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:zadana_delivery/features/order_details/presentation/screens/assignment_detail_entry_screen.dart';
import 'package:zadana_delivery/features/order_details/presentation/screens/order_delivery_success_screen.dart';
import 'package:zadana_delivery/features/order_details/presentation/screens/order_details_screen.dart';
import 'package:zadana_delivery/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:zadana_delivery/features/profile/presentation/screens/personal_info_screen.dart';
import 'package:zadana_delivery/features/profile/presentation/screens/security_documents_screen.dart';
import 'package:zadana_delivery/features/profile/presentation/screens/vehicle_info_screen.dart';
import 'package:zadana_delivery/features/settings/presentation/screens/privacy_screen.dart';
import 'package:zadana_delivery/features/settings/presentation/screens/security_screen.dart';
import 'package:zadana_delivery/features/settings/presentation/screens/support_help_screen.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.authGate:
        return _pageRoute(settings, const AuthGateScreen());
      case AppRoutes.login:
        final initialIdentifier = settings.arguments as String?;
        return _pageRoute(
          settings,
          LoginScreen(initialIdentifier: initialIdentifier),
        );
      case AppRoutes.signUp:
        return _pageRoute(settings, const SignUpScreen());
      case AppRoutes.forgetPassword:
        return _pageRoute(settings, const ForgotPasswordScreen());
      case AppRoutes.resetPassword:
        final identifier = settings.arguments as String? ?? '';
        return _pageRoute(
          settings,
          ResetPasswordScreen(identifier: identifier),
        );
      case AppRoutes.driverProfileCompletion:
        final draft = settings.arguments as RegisterAccountDraft?;
        return _pageRoute(
          settings,
          DriverProfileCompletionScreen(registrationDraft: draft),
        );
      case AppRoutes.accountPendingApproval:
        return _pageRoute(
          settings,
          AccountPendingApprovalScreen(
            initialStatus: settings.arguments as DriverAccountStatusEntity?,
          ),
        );
      case AppRoutes.accountBlocked:
        return _pageRoute(
          settings,
          AccountBlockedScreen(
            initialStatus: settings.arguments as DriverAccountStatusEntity?,
          ),
        );
      case AppRoutes.driverHome:
        return _pageRoute(settings, const AppShellScreen());
      case AppRoutes.completedOrders:
        return _pageRoute(settings, const AppShellScreen(initialIndex: 1));
      case AppRoutes.wallet:
        return _pageRoute(settings, const AppShellScreen(initialIndex: 2));
      case AppRoutes.profile:
        return _pageRoute(settings, const AppShellScreen(initialIndex: 3));
      case AppRoutes.mainShell:
        final args = settings.arguments;
        final initialIndex = args is Map<String, dynamic>
            ? args['initialIndex'] as int? ?? 0
            : args is int
            ? args
            : 0;
        return _pageRoute(settings, AppShellScreen(initialIndex: initialIndex));
      case AppRoutes.notifications:
        return _pageRoute(settings, const NotificationsScreen());
      case AppRoutes.supportHelp:
        return _pageRoute(settings, const SupportHelpScreen());
      case AppRoutes.driverSupportCases:
        return _pageRoute(settings, const DriverSupportCasesScreen());
      case AppRoutes.driverSupportCaseDetails:
        final args = settings.arguments;
        if (args is Map<String, dynamic>) {
          final caseId = args['caseId']?.toString().trim() ?? '';
          if (caseId.isNotEmpty) {
            return _pageRoute(
              settings,
              DriverSupportCaseDetailEntryScreen(caseId: caseId),
            );
          }
        }
        if (args is! DriverSupportCaseEntity) {
          return unDefinedRoute(settings.name);
        }
        return _pageRoute(
          settings,
          DriverSupportCaseDetailsScreen(initialCase: args),
        );
      case AppRoutes.privacy:
        return _pageRoute(settings, const PrivacyScreen());
      case AppRoutes.security:
        return _pageRoute(settings, const SecurityScreen());
      case AppRoutes.profileEdit:
        return _pageRoute(settings, const EditProfileScreen());
      case AppRoutes.profilePersonalInfo:
        return _pageRoute(settings, const PersonalInfoScreen());
      case AppRoutes.profileVehicleInfo:
        return _pageRoute(settings, const VehicleInfoScreen());
      case AppRoutes.profileSecurityDocuments:
        return _pageRoute(settings, const SecurityDocumentsScreen());
      case AppRoutes.orderDetails:
        final args = settings.arguments;
        if (args is Map<String, dynamic>) {
          final assignmentId = args['assignmentId']?.toString().trim() ?? '';
          if (assignmentId.isNotEmpty) {
            return _pageRoute(
              settings,
              AssignmentDetailEntryScreen(assignmentId: assignmentId),
            );
          }
        }
        if (args is! Map<String, dynamic> ||
            !args.containsKey('order') ||
            !args.containsKey('driverLocation')) {
          return unDefinedRoute(settings.name);
        }

        return _pageRoute(
          settings,
          OrderDetailsScreen(
            order: args['order'],
            driverLocation: args['driverLocation'],
            startAccepted: args['startAccepted'] as bool? ?? false,
            initialSuccessMessage: args['initialSuccessMessage'] as String?,
          ),
        );
      case AppRoutes.orderDeliverySuccess:
        final args = settings.arguments;
        final message = args is Map<String, dynamic>
            ? args['message'] as String?
            : null;
        return _pageRoute(
          settings,
          OrderDeliverySuccessScreen(message: message),
        );
      default:
        return unDefinedRoute(settings.name);
    }
  }

  static MaterialPageRoute<dynamic> _pageRoute(
    RouteSettings settings,
    Widget page,
  ) {
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }

  static Route<dynamic> unDefinedRoute(String? routeName) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('No Route Found')),
        body: Center(
          child: Text('No route found for ${routeName ?? 'unknown'}'),
        ),
      ),
    );
  }
}
