import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/constants/assets.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/auth/account_status/domain/entities/driver_account_status_entity.dart';
import 'package:zadana_delivery/features/auth/session/presentation/manager/auth_gate_cubit.dart';
import 'package:zadana_delivery/features/auth/session/presentation/manager/auth_gate_event.dart';
import 'package:zadana_delivery/features/auth/session/presentation/manager/auth_gate_state.dart';

class AccountBlockedScreen extends StatefulWidget {
  const AccountBlockedScreen({super.key});

  @override
  State<AccountBlockedScreen> createState() => _AccountBlockedScreenState();
}

class _AccountBlockedScreenState extends State<AccountBlockedScreen> {
  late final AuthGateCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<AuthGateCubit>();
    _cubit.doIntent(const AuthGateStartedEvent());
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<AuthGateCubit, AuthGateState>(
        listener: (context, state) {
          if (state.failure != null) {
            CustomSnackbar.showError(
              context: context,
              message: state.failure!.errorMessage,
            );
            _cubit.doIntent(const AuthGateFeedbackHandledEvent());
          }

          if (state.logoutSucceeded && state.targetRoute == AppRoutes.login) {
            CustomSnackbar.showInfo(
              context: context,
              message: context.localization.profile_logout_success,
            );
            context.pushNamedAndRemoveUntil(
              AppRoutes.login,
              rootNavigator: true,
              predicate: (route) => false,
            );
          }
        },
        builder: (context, state) {
          final backendMessage = _primaryBlockedMessage(state.accountStatus);
          final backendDetail = _secondaryBlockedMessage(state.accountStatus);

          return Scaffold(
            backgroundColor: color.surface,
            body: Stack(
              children: [
                AbsorbPointer(
                  absorbing: state.isLoggingOut,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.xl,
                        vertical: Spacing.base,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Spacer(),
                              _NotificationButton(
                                count: 1,
                                onTap: () =>
                                    context.pushNamed(AppRoutes.notifications),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 132,
                                      height: 132,
                                      decoration: BoxDecoration(
                                        color: color.error.withValues(
                                          alpha: 0.08,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(18),
                                        child: Lottie.asset(
                                          Assets.noAccess,
                                          repeat: true,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: Spacing.lg),
                                    Text(
                                      locale.auth_blocked_title,
                                      textAlign: TextAlign.center,
                                      style: getBoldStyle(
                                        fontFamily: FontConstant.cairo,
                                        fontSize: FontSize.size24,
                                        color: color.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: Spacing.sm),
                                    Text(
                                      backendMessage.isNotEmpty
                                          ? backendMessage
                                          : locale.auth_blocked_description,
                                      textAlign: TextAlign.center,
                                      style: getRegularStyle(
                                        fontFamily: FontConstant.cairo,
                                        fontSize: FontSize.size14,
                                        color: color.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: Spacing.lg),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: color.surfaceContainerLow,
                                        borderRadius: BorderRadius.circular(22),
                                        border: Border.all(
                                          color: color.error.withValues(
                                            alpha: 0.16,
                                          ),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: color.shadow.withValues(
                                              alpha: 0.06,
                                            ),
                                            blurRadius: 16,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 42,
                                            height: 42,
                                            decoration: BoxDecoration(
                                              color: color.error.withValues(
                                                alpha: 0.10,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: Icon(
                                              Icons.block_rounded,
                                              color: color.error,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              backendDetail.isNotEmpty
                                                  ? backendDetail
                                                  : backendMessage.isNotEmpty
                                                  ? backendMessage
                                                  : locale
                                                        .auth_blocked_access_hint,
                                              style: getRegularStyle(
                                                fontFamily: FontConstant.cairo,
                                                fontSize: FontSize.size13,
                                                color: color.onSurface,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: Spacing.base),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            color.error.withValues(alpha: 0.14),
                                            color.error.withValues(alpha: 0.06),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.support_agent_rounded,
                                            color: AppColors.error,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              backendMessage.isNotEmpty
                                                  ? backendMessage
                                                  : locale
                                                        .auth_blocked_support_hint,
                                              style: getMediumStyle(
                                                fontFamily: FontConstant.cairo,
                                                fontSize: FontSize.size13,
                                                color: color.onSurface,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: Spacing.xl),
                                    AppButton.filled(
                                      text: locale.auth_contact_support,
                                      onPressed: () => context.pushNamed(
                                        AppRoutes.supportHelp,
                                      ),
                                      color: color.error,
                                      height: 54,
                                      borderRadius: 18,
                                    ),
                                    const SizedBox(height: Spacing.md),
                                    AppButton.outlined(
                                      text: locale.auth_logout_account,
                                      onPressed: () => _cubit.doIntent(
                                        const AuthGateLogoutRequestedEvent(),
                                      ),
                                      color: color.error,
                                      textColor: color.error,
                                      height: 54,
                                      borderRadius: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (state.isLoggingOut) ...[
                  Positioned.fill(
                    child: ColoredBox(
                      color: Colors.black.withValues(alpha: 0.08),
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

  String _primaryBlockedMessage(DriverAccountStatusEntity? status) {
    return status?.primaryBlockedMessage.trim() ?? '';
  }

  String _secondaryBlockedMessage(DriverAccountStatusEntity? status) {
    if (status == null) return '';

    for (final candidate in [
      status.restrictionMessage,
      status.suspensionReason,
      status.reviewNote,
      if (status.message.trim() != status.primaryBlockedMessage) status.message,
    ]) {
      final normalized = candidate?.trim() ?? '';
      if (normalized.isNotEmpty) return normalized;
    }

    final enforcementLevel = status.gateStatus.trim().isNotEmpty
        ? status.gateStatus.trim()
        : status.accountStatus.trim();
    if (enforcementLevel.isEmpty) return '';

    return 'Status: $enforcementLevel';
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: color.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: color.outlineVariant.withValues(alpha: 0.45),
                ),
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: color.onSurface,
              ),
            ),
          ),
        ),
        if (count > 0)
          Positioned(
            top: -4,
            right: -2,
            child: Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$count',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size11,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
