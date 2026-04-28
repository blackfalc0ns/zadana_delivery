import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/general_cubit/local_cubit.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/app_shell/presentation/screens/app_shell_screen.dart';
import 'package:zadana_delivery/features/profile/presentation/manager/profile_cubit.dart';
import 'package:zadana_delivery/features/profile/presentation/manager/profile_state.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_loading_skeleton.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_screen_content.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ProfileCubit>()..loadProfile();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.failure != null && state.profile != null) {
            CustomSnackbar.showError(
              context: context,
              message: state.failure!.errorMessage,
            );
            _cubit.clearError();
          }
        },
        builder: (context, state) {
          if (state.profile == null && state.isLoading) {
            return const ProfileScreenLoadingSkeleton();
          }

          if (state.profile == null &&
              state.failure != null &&
              !state.isLoading) {
            return Scaffold(
              backgroundColor: context.colorScheme.surface,
              body: SafeArea(
                child: ApiErrorWidget(
                  exception: state.failure!.asException,
                  onRetry: _cubit.loadProfile,
                  onGoBack: _cubit.clearError,
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: context.colorScheme.surface,
            body: Stack(
              children: [
                ProfileScreenContent(
                  state: state,
                  onActionTap: _handleAction,
                  onNotificationsChanged: _cubit.updateNotifications,
                ),
                if (state.isLoggingOut) ...[
                  Positioned.fill(
                    child: AbsorbPointer(
                      child: ColoredBox(
                        color: Colors.black.withValues(alpha: 0.10),
                      ),
                    ),
                  ),
                  const Positioned.fill(child: CustomProgressIndicator()),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleAction(ProfileActionType type) async {
    switch (type) {
      case ProfileActionType.personalInfo:
        return _open(AppRoutes.profileEdit);
      case ProfileActionType.vehicleInfo:
        return _open(AppRoutes.profileVehicleInfo);
      case ProfileActionType.documents:
        return _open(AppRoutes.profileSecurityDocuments);
      case ProfileActionType.orders:
        return _openOrdersTab();
      case ProfileActionType.language:
        return _showLanguageSheet();
      case ProfileActionType.notifications:
        return _open(AppRoutes.notifications);
      case ProfileActionType.security:
        return _open(AppRoutes.forgetPassword);
      case ProfileActionType.support:
        return _open(AppRoutes.supportHelp);
      case ProfileActionType.privacy:
        return _open(AppRoutes.privacy);
      case ProfileActionType.logout:
        return _logout();
    }
  }

  Future<void> _logout() async {
    final confirmed = await _showLogoutConfirmationDialog();
    if (confirmed != true || !mounted) return;

    final locale = context.localization;
    final didLogout = await _cubit.logout();
    if (!mounted) return;

    if (!didLogout) {
      final errorMessage = _cubit.state.failure?.errorMessage;
      if ((errorMessage ?? '').trim().isNotEmpty) {
        CustomSnackbar.showError(context: context, message: errorMessage!);
      }
      return;
    }

    CustomSnackbar.showInfo(
      context: context,
      message: locale.profile_logout_success,
    );
    context.pushNamedAndRemoveUntil(
      AppRoutes.login,
      rootNavigator: true,
      predicate: (route) => false,
    );
  }

  Future<bool?> _showLogoutConfirmationDialog() {
    final locale = context.localization;
    final colorScheme = context.colorScheme;

    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.25),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.12),
                  blurRadius: 32,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: colorScheme.error.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.logout_rounded,
                        size: 28,
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    locale.logout,
                    textAlign: TextAlign.center,
                    style: Theme.of(dialogContext).textTheme.titleLarge
                        ?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    locale.logout_confirm,
                    textAlign: TextAlign.center,
                    style: Theme.of(dialogContext).textTheme.bodyMedium
                        ?.copyWith(
                          height: 1.5,
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(false),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            side: BorderSide(
                              color: colorScheme.outlineVariant.withValues(
                                alpha: 0.65,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            MaterialLocalizations.of(context).cancelButtonLabel,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            backgroundColor: colorScheme.error,
                            foregroundColor: colorScheme.onError,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(locale.logout),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _open(String route) async {
    await context.pushNamed(route, rootNavigator: true);
    if (mounted) _cubit.loadProfile();
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
