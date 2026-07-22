import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/general_cubit/local_cubit.dart';
import 'package:zadana_delivery/core/services/trip_request_overlay_service.dart';
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

class _ProfileScreenState extends State<ProfileScreen>
    with WidgetsBindingObserver {
  late final ProfileCubit _cubit;
  late final TripRequestOverlayService _overlayService;
  late final AppLifecycleListener _lifecycleListener;
  bool _hasOverlayPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _lifecycleListener = AppLifecycleListener(onResume: _onAppResumed);
    _cubit = getIt<ProfileCubit>()..loadProfile();
    _overlayService = getIt<TripRequestOverlayService>();
    _checkOverlayPermission();
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _cubit.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('[ProfileScreen] didChangeAppLifecycleState: $state');
    if (state == AppLifecycleState.resumed) {
      _onAppResumed();
    }
  }

  void _onAppResumed() {
    debugPrint('[ProfileScreen] App resumed — checking overlay permission');
    _checkOverlayPermission();
  }

  Future<void> _checkOverlayPermission() async {
    final granted = await _overlayService.hasPermission();
    debugPrint('[ProfileScreen] Overlay permission check: $granted');
    if (mounted) {
      setState(() => _hasOverlayPermission = granted);
    }
  }

  Future<void> _onOverlaySwitchTapped(bool value) async {
    debugPrint(
      '[ProfileScreen] Overlay switch tapped, value=$value current=$_hasOverlayPermission',
    );
    await _overlayService.openOverlaySettings();
  }

  Future<void> _openOverlayPermissionSettings() async {
    debugPrint('[ProfileScreen] Opening overlay permission settings');
    await _overlayService.openOverlaySettings();
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
                  onOverlayChanged: _onOverlaySwitchTapped,
                  overlayEnabled: _hasOverlayPermission,
                  onRefresh: _cubit.loadProfile,
                ),
                if (state.isLoggingOut || state.isClosingAccount) ...[
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
      case ProfileActionType.accountStatus:
        final profile = _cubit.state.profile;
        return _open(
          profile?.isBlocked == true
              ? AppRoutes.accountBlocked
              : AppRoutes.accountPendingApproval,
        );
      case ProfileActionType.personalInfo:
        return _openWithProfile(AppRoutes.profilePersonalInfo);
      case ProfileActionType.vehicleInfo:
        return _openWithProfile(AppRoutes.profileVehicleInfo);
      case ProfileActionType.documents:
        return _openWithProfile(AppRoutes.profileSecurityDocuments);
      case ProfileActionType.orders:
        return _openOrdersTab();
      case ProfileActionType.language:
        return _showLanguageSheet();
      case ProfileActionType.notifications:
        return _open(AppRoutes.notifications);
      case ProfileActionType.overlayPermission:
        return _openOverlayPermissionSettings();
      case ProfileActionType.security:
        return _open(AppRoutes.forgetPassword);
      case ProfileActionType.support:
        return _open(AppRoutes.driverSupportCases);
      case ProfileActionType.privacy:
        return _open(AppRoutes.privacy);
      case ProfileActionType.deleteAccount:
        return _requestAccountClosure();
      case ProfileActionType.logout:
        return _logout();
    }
  }

  Future<void> _requestAccountClosure() async {
    final eligibility = await _cubit.checkAccountCloseEligibility();
    if (!mounted) return;

    switch (eligibility) {
      case AccountCloseEligibility.activeWithdrawal:
        await _showAccountCloseBlockedDialog(
          title: _isArabic
              ? 'لا يمكن حذف الحساب الآن'
              : 'Unable to delete account',
          message: _isArabic
              ? 'يوجد طلب سحب قيد الانتظار أو المعالجة. راجع طلبات السحب أولًا.'
              : 'A withdrawal is pending or processing. Review your withdrawals first.',
          openWallet: true,
        );
        return;
      case AccountCloseEligibility.codOutstanding:
        await _showAccountCloseBlockedDialog(
          title: _isArabic ? 'تسوية COD مطلوبة' : 'COD settlement required',
          message: _isArabic
              ? 'لا يمكن حذف الحساب قبل تسوية مستحقات COD مع الإدارة.'
              : 'Settle your outstanding COD balance with support before deleting your account.',
        );
        return;
      case AccountCloseEligibility.unknown:
        CustomSnackbar.showError(
          context: context,
          message: _isArabic
              ? 'تعذر التحقق من حالة المحفظة. حاول مرة أخرى.'
              : 'Unable to verify your wallet status. Please try again.',
        );
        return;
      case AccountCloseEligibility.allowed:
        break;
    }

    final password = await _showAccountCloseConfirmationDialog();
    if (password == null || !mounted) return;

    final result = await _cubit.closeAccount(password: password);
    if (!mounted) return;
    switch (result) {
      case AccountCloseResult.success:
        await _showAccountClosedDialog();
        if (!mounted) return;
        context.pushNamedAndRemoveUntil(
          AppRoutes.login,
          rootNavigator: true,
          predicate: (route) => false,
        );
      case AccountCloseResult.activeWithdrawal:
        await _showAccountCloseBlockedDialog(
          title: _isArabic
              ? 'لا يمكن حذف الحساب الآن'
              : 'Unable to delete account',
          message: _isArabic
              ? 'يوجد طلب سحب قيد الانتظار أو المعالجة. راجع طلبات السحب أولًا.'
              : 'A withdrawal is pending or processing. Review your withdrawals first.',
          openWallet: true,
        );
      case AccountCloseResult.codOutstanding:
        await _showAccountCloseBlockedDialog(
          title: _isArabic ? 'تسوية COD مطلوبة' : 'COD settlement required',
          message: _isArabic
              ? 'لا يمكن حذف الحساب قبل تسوية مستحقات COD مع الإدارة.'
              : 'Settle your outstanding COD balance with support before deleting your account.',
        );
      case AccountCloseResult.invalidPassword:
        CustomSnackbar.showError(
          context: context,
          message: _isArabic ? 'كلمة المرور غير صحيحة.' : 'Incorrect password.',
        );
      case AccountCloseResult.failed:
        CustomSnackbar.showError(
          context: context,
          message: _isArabic
              ? 'تعذر حذف الحساب. حاول مرة أخرى.'
              : 'Unable to delete the account. Please try again.',
        );
    }
  }

  bool get _isArabic => context.localization.localeName.startsWith('ar');

  Future<String?> _showAccountCloseConfirmationDialog() async {
    final confirmationController = TextEditingController();
    final passwordController = TextEditingController();
    final colorScheme = context.colorScheme;
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          final canDelete =
              confirmationController.text.trim() == 'DELETE' &&
              passwordController.text.isNotEmpty;
          return AlertDialog(
            icon: Icon(Icons.warning_amber_rounded, color: colorScheme.error),
            title: Text(
              _isArabic ? 'حذف الحساب نهائيًا؟' : 'Delete account permanently?',
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _isArabic
                        ? 'سيتم إغلاق حسابك وتسجيل خروجك من التطبيق. إذا أردت الرجوع مرة أخرى، تواصل مع الدعم.'
                        : 'Your account will be closed and you will be signed out. Contact support if you need to return later.',
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmationController,
                    textCapitalization: TextCapitalization.characters,
                    onChanged: (_) => setDialogState(() {}),
                    decoration: InputDecoration(
                      labelText: _isArabic
                          ? 'اكتب DELETE للتأكيد'
                          : 'Type DELETE to confirm',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    onChanged: (_) => setDialogState(() {}),
                    decoration: InputDecoration(
                      labelText: _isArabic ? 'كلمة المرور' : 'Password',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  MaterialLocalizations.of(context).cancelButtonLabel,
                ),
              ),
              FilledButton(
                onPressed: canDelete
                    ? () => Navigator.of(
                        dialogContext,
                      ).pop(passwordController.text)
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.error,
                ),
                child: Text(_isArabic ? 'حذف الحساب' : 'Delete account'),
              ),
            ],
          );
        },
      ),
    );
    confirmationController.dispose();
    passwordController.dispose();
    return result;
  }

  Future<void> _showAccountClosedDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          Icons.check_circle_rounded,
          color: context.colorScheme.primary,
        ),
        title: Text(_isArabic ? 'تم حذف الحساب' : 'Account deleted'),
        content: Text(
          _isArabic
              ? 'تم تسجيل خروجك. لو حابب ترجع تاني، كلم الدعم.'
              : 'You have been signed out. Contact support if you want to return.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(_isArabic ? 'حسنًا' : 'OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAccountCloseBlockedDialog({
    required String title,
    required String message,
    bool openWallet = false,
  }) async {
    final shouldOpenWallet = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          Icons.info_outline_rounded,
          color: context.colorScheme.error,
        ),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(_isArabic ? 'حسنًا' : 'OK'),
          ),
          if (openWallet)
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(_isArabic ? 'عرض السحوبات' : 'View withdrawals'),
            ),
        ],
      ),
    );
    if (shouldOpenWallet == true && mounted) {
      context.pushNamed(AppRoutes.wallet, rootNavigator: true);
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

  Future<void> _openWithProfile(String route) async {
    await context.pushNamed(
      route,
      rootNavigator: true,
      arguments: _cubit.state.profile,
    );
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
          required String flagAsset,
          required Future<void> Function() onTap,
        }) {
          final isSelected = currentCode == code;
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              Navigator.of(sheetContext).pop();
              await onTap();
              if (mounted) setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
              child: Row(
                children: [
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      color: sheetColor.primary,
                      size: 24,
                    )
                  else
                    Icon(
                      Icons.circle_outlined,
                      color: sheetColor.outlineVariant,
                      size: 24,
                    ),
                  const Spacer(),
                  Text(
                    title,
                    style: TextStyle(
                      color: sheetColor.onSurface,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(flagAsset, style: const TextStyle(fontSize: 22)),
                ],
              ),
            ),
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
                Center(
                  child: Text(
                    locale.select_language,
                    style: TextStyle(
                      color: sheetColor.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Divider(
                  height: 1,
                  color: sheetColor.outlineVariant.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 8),
                option(
                  code: 'ar',
                  title: locale.arabic,
                  flagAsset: '🇸🇦',
                  onTap: localeCubit.setArabic,
                ),
                Divider(
                  height: 1,
                  color: sheetColor.outlineVariant.withValues(alpha: 0.3),
                ),
                option(
                  code: 'en',
                  title: locale.english,
                  flagAsset: '🇬🇧',
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
