import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/auth/session/presentation/manager/auth_gate_cubit.dart';
import 'package:zadana_delivery/features/auth/session/presentation/manager/auth_gate_event.dart';
import 'package:zadana_delivery/features/auth/session/presentation/manager/auth_gate_state.dart';

class AccountPendingApprovalScreen extends StatefulWidget {
  const AccountPendingApprovalScreen({super.key});

  @override
  State<AccountPendingApprovalScreen> createState() =>
      _AccountPendingApprovalScreenState();
}

class _AccountPendingApprovalScreenState
    extends State<AccountPendingApprovalScreen> {
  late final AuthGateCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<AuthGateCubit>();
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
          return Scaffold(
            backgroundColor: color.surface,
            body: SafeArea(
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
                          onTap: () => context.pushNamed(AppRoutes.notifications),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: Lottie.asset(
                                  Assets.blueLoading,
                                  repeat: true,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: Spacing.md),
                              SizedBox(
                                height: 155,
                                child: SvgPicture.asset(Assets.fastDelivery),
                              ),
                              const SizedBox(height: Spacing.lg),
                              Text(
                                locale.auth_pending_title,
                                textAlign: TextAlign.center,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.cairo,
                                  fontSize: FontSize.size24,
                                  color: color.onSurface,
                                ),
                              ),
                              const SizedBox(height: Spacing.sm),
                              Text(
                                locale.auth_pending_description,
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
                                    color: color.primary.withValues(alpha: 0.14),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: color.shadow.withValues(alpha: 0.06),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        color: color.primary.withValues(
                                          alpha: 0.10,
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Icon(
                                        Icons.notifications_active_outlined,
                                        color: color.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        locale.auth_pending_notification_hint,
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
                                      AppColors.secondary.withValues(alpha: 0.14),
                                      AppColors.secondary.withValues(alpha: 0.06),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_filled_rounded,
                                      color: AppColors.secondary,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        locale.auth_pending_eta_hint,
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
                                text: locale.auth_logout_account,
                                onPressed: () => _cubit.doIntent(
                                  const AuthGateLogoutRequestedEvent(),
                                ),
                                isLoading: state.isLoggingOut,
                                color: color.error,
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
          );
        },
      ),
    );
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
