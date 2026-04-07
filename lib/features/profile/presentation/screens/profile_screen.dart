import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_snackbar.dart';
import 'package:zadana_delivery/features/app_shell/presentation/screens/app_shell_screen.dart';
import 'package:zadana_delivery/features/profile/presentation/controllers/profile_screen_controller.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_screen_content.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileScreenController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProfileScreenController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: ProfileScreenContent(
        controller: _controller,
        onActionTap: _handleAction,
      ),
    );
  }

  Future<void> _handleAction(ProfileActionType type) async {
    switch (type) {
      case ProfileActionType.editProfile:
        return _open(AppRoutes.driverProfileCompletion);
      case ProfileActionType.orders:
        return _openOrdersTab();
      case ProfileActionType.language:
        final locale = context.localization;
        CustomSnackbar.showInfo(
          context: context,
          message: locale.profile_language_info,
        );
        return;
      case ProfileActionType.notifications:
        return _open(AppRoutes.notifications);
      case ProfileActionType.security:
        return _open(AppRoutes.security);
      case ProfileActionType.support:
        return _open(AppRoutes.supportHelp);
      case ProfileActionType.privacy:
        return _open(AppRoutes.privacy);
      case ProfileActionType.logout:
        return _logout();
    }
  }

  Future<void> _logout() async {
    final locale = context.localization;
    await _controller.logout();
    if (!mounted) return;

    CustomSnackbar.showInfo(
      context: context,
      message: locale.profile_logout_success,
    );
    context.pushNamedAndRemoveUntil(
      AppRoutes.login,
      predicate: (route) => false,
    );
  }

  Future<void> _open(String route) async {
    await context.pushNamed(route);
    if (mounted) setState(() {});
  }

  Future<void> _openOrdersTab() async {
    final shellScope = AppShellScreen.maybeOf(context);
    if (shellScope != null) {
      shellScope.switchToTab(1);
      return;
    }

    context.pushNamedAndRemoveUntil(
      AppRoutes.completedOrders,
      predicate: (route) => false,
    );
  }
}
