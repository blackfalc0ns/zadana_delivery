import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/general_cubit/local_cubit.dart';
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
    _controller = getIt<ProfileScreenController>();
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
        return _showLanguageSheet();
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
    try {
      await _controller.logout();
    } catch (error) {
      if (!mounted) return;
      CustomSnackbar.showError(
        context: context,
        message: error.toString().replaceFirst('Exception: ', ''),
      );
      return;
    }
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

  Future<void> _showLanguageSheet() async {
    final locale = context.localization;
    final color = context.colorScheme;
    final localeCubit = LocaleCubitScope.of(context);
    final currentCode = localeCubit.locale.languageCode;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: color.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final sheetColor = Theme.of(sheetContext).colorScheme;

        Widget option({
          required String code,
          required String title,
          required Future<void> Function() onTap,
        }) {
          final isSelected = currentCode == code;
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            tileColor: isSelected
                ? sheetColor.primary.withValues(alpha: 0.10)
                : Colors.transparent,
            leading: Icon(
              Icons.language_rounded,
              color: isSelected
                  ? sheetColor.primary
                  : sheetColor.onSurfaceVariant,
            ),
            title: Text(
              title,
              style: TextStyle(
                color: sheetColor.onSurface,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            trailing: isSelected
                ? Icon(Icons.check_rounded, color: sheetColor.primary)
                : null,
            onTap: () async {
              Navigator.of(sheetContext).pop();
              await onTap();
              if (mounted) setState(() {});
            },
          );
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: sheetColor.outlineVariant,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  locale.select_language,
                  style: TextStyle(
                    color: sheetColor.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                option(
                  code: 'ar',
                  title: locale.arabic,
                  onTap: localeCubit.setArabic,
                ),
                const SizedBox(height: 8),
                option(
                  code: 'en',
                  title: locale.english,
                  onTap: localeCubit.setEnglish,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
