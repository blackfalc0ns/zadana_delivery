import 'dart:async';

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
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/auth/account_status/domain/entities/driver_account_status_entity.dart';
import 'package:zadana_delivery/features/auth/session/presentation/manager/auth_gate_cubit.dart';
import 'package:zadana_delivery/features/auth/session/presentation/manager/auth_gate_event.dart';
import 'package:zadana_delivery/features/auth/session/presentation/manager/auth_gate_state.dart';
import 'package:zadana_delivery/features/auth/session/presentation/widgets/auth_status_notification_button.dart';
import 'package:zadana_delivery/features/driver_support/presentation/models/driver_account_support_appeal_args.dart';
import 'package:zadana_delivery/features/profile/domain/entities/driver_rejection_policy_entity.dart';
import 'package:zadana_delivery/features/profile/domain/entities/driver_unified_profile_entity.dart';
import 'package:zadana_delivery/features/profile/domain/usecase/get_driver_unified_profile_usecase.dart';

class AccountBlockedScreen extends StatefulWidget {
  const AccountBlockedScreen({super.key, this.initialStatus});

  final DriverAccountStatusEntity? initialStatus;

  @override
  State<AccountBlockedScreen> createState() => _AccountBlockedScreenState();
}

class _AccountBlockedScreenState extends State<AccountBlockedScreen>
    with WidgetsBindingObserver {
  late final AuthGateCubit _cubit;
  late final Future<DriverUnifiedProfileEntity?> _profileFuture;
  Timer? _recheckTimer;
  bool _isNavigatingAway = false;

  static const Duration _recheckInterval = Duration(seconds: 30);

  @override
  void initState() {
    super.initState();
    _cubit = getIt<AuthGateCubit>();
    _profileFuture = _loadProfile();
    WidgetsBinding.instance.addObserver(this);
    _startPeriodicRecheck();
  }

  @override
  void dispose() {
    _recheckTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _cubit.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !_isNavigatingAway) {
      _recheckAccountStatus();
    }
  }

  void _startPeriodicRecheck() {
    _recheckTimer = Timer.periodic(_recheckInterval, (_) {
      if (!_isNavigatingAway) {
        _recheckAccountStatus();
      }
    });
  }

  void _recheckAccountStatus() {
    _cubit.doIntent(const AuthGateStartedEvent());
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
            _isNavigatingAway = true;
            _recheckTimer?.cancel();
            context.pushNamedAndRemoveUntil(
              AppRoutes.login,
              rootNavigator: true,
              predicate: (route) => false,
            );
            return;
          }

          // Ban lifted — navigate to the resolved route
          if (!state.isLoading &&
              !state.isLoggingOut &&
              state.targetRoute != null &&
              state.targetRoute != AppRoutes.accountBlocked &&
              !_isNavigatingAway) {
            _isNavigatingAway = true;
            _recheckTimer?.cancel();
            context.pushNamedAndRemoveUntil(
              state.targetRoute!,
              rootNavigator: true,
              predicate: (route) => false,
            );
          }
        },
        builder: (context, state) {
          final resolvedStatus = state.accountStatus ?? widget.initialStatus;
          final isArabic = Localizations.localeOf(context).languageCode == 'ar';
          return FutureBuilder<DriverUnifiedProfileEntity?>(
            future: _profileFuture,
            builder: (context, snapshot) {
              final profile = snapshot.data;
              final rejectionPolicy = profile?.rejectionPolicy;
              final backendMessage = _primaryBlockedMessage(
                resolvedStatus,
                rejectionPolicy: rejectionPolicy,
              );
              final backendDetail = _secondaryBlockedMessage(
                resolvedStatus,
                rejectionPolicy: rejectionPolicy,
              );

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
                                  AuthStatusNotificationButton(
                                    onTap: () => context.pushNamed(
                                      AppRoutes.notifications,
                                    ),
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
                                            borderRadius: BorderRadius.circular(
                                              22,
                                            ),
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
                                                      : backendMessage
                                                            .isNotEmpty
                                                      ? backendMessage
                                                      : locale
                                                            .auth_blocked_access_hint,
                                                  style: getRegularStyle(
                                                    fontFamily:
                                                        FontConstant.cairo,
                                                    fontSize: FontSize.size13,
                                                    color: color.onSurface,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (rejectionPolicy?.hasData ==
                                            true) ...[
                                          const SizedBox(height: Spacing.base),
                                          _RejectionPolicySummaryCard(
                                            policy: rejectionPolicy!,
                                          ),
                                        ],
                                        const SizedBox(height: Spacing.base),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                color.error.withValues(
                                                  alpha: 0.14,
                                                ),
                                                color.error.withValues(
                                                  alpha: 0.06,
                                                ),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              22,
                                            ),
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
                                                    fontFamily:
                                                        FontConstant.cairo,
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
                                          text: _supportLabel(
                                            resolvedStatus,
                                            isArabic: isArabic,
                                            fallback:
                                                locale.auth_contact_support,
                                          ),
                                          onPressed: () => context.pushNamed(
                                            AppRoutes
                                                .driverAccountSupportAppeal,
                                            arguments:
                                                DriverAccountSupportAppealArgs(
                                                  initialReasonCode:
                                                      resolvedStatus
                                                          ?.supportCta
                                                          ?.reasonType ??
                                                      _resolveSupportReasonCode(
                                                        resolvedStatus,
                                                      ),
                                                  buttonLabel: _supportLabel(
                                                    resolvedStatus,
                                                    isArabic: isArabic,
                                                    fallback: locale
                                                        .auth_contact_support,
                                                  ),
                                                ),
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
          );
        },
      ),
    );
  }

  Future<DriverUnifiedProfileEntity?> _loadProfile() async {
    final result = await getIt<GetDriverUnifiedProfileUseCase>().call();
    return switch (result) {
      ApiSuccessResult() => result.data,
      ApiErrorResult() => null,
    };
  }

  String _primaryBlockedMessage(
    DriverAccountStatusEntity? status, {
    DriverRejectionPolicyEntity? rejectionPolicy,
  }) {
    final policyMessage = rejectionPolicy?.restrictionMessage?.trim() ?? '';
    if (policyMessage.isNotEmpty) return policyMessage;
    return status?.primaryBlockedMessage.trim() ?? '';
  }

  String _secondaryBlockedMessage(
    DriverAccountStatusEntity? status, {
    DriverRejectionPolicyEntity? rejectionPolicy,
  }) {
    if (rejectionPolicy?.isFrozen == true) {
      return context.localization.auth_blocked_rejection_policy_hint;
    }

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

  String _supportLabel(
    DriverAccountStatusEntity? status, {
    required bool isArabic,
    required String fallback,
  }) {
    final preferred = isArabic
        ? status?.supportCta?.labelAr
        : status?.supportCta?.labelEn;
    final normalized = preferred?.trim() ?? '';
    if (normalized.isNotEmpty) return normalized;
    return fallback;
  }

  String _resolveSupportReasonCode(DriverAccountStatusEntity? status) {
    final gate = status?.normalizedGateStatus ?? '';
    final account = status?.normalizedAccountStatus ?? '';

    if (gate == 'loginlocked') {
      return 'login_locked';
    }
    if (gate == 'banned' || account == 'blocked') {
      return 'account_banned';
    }
    if (gate == 'suspended' || account == 'suspended') {
      return 'account_suspended';
    }
    return 'other';
  }
}

class _RejectionPolicySummaryCard extends StatelessWidget {
  const _RejectionPolicySummaryCard({required this.policy});

  final DriverRejectionPolicyEntity policy;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.error.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locale.profile_rejection_policy_title,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          _BlockedMetricRow(
            label: locale.profile_rejection_today_label,
            value: '${policy.dailyRejections}/${policy.dailyLimit}',
          ),
          const SizedBox(height: 8),
          _BlockedMetricRow(
            label: locale.profile_rejection_today_remaining_label,
            value: '${policy.remainingBeforeFreeze}',
          ),
          const SizedBox(height: 10),
          _BlockedMetricRow(
            label: locale.profile_rejection_week_label,
            value: '${policy.weeklyRejections}/${policy.weeklyLimit}',
          ),
          const SizedBox(height: 8),
          _BlockedMetricRow(
            label: locale.profile_rejection_week_remaining_label,
            value: '${policy.remainingBeforeWeeklyFreeze}',
          ),
          if (policy.isFrozen) ...[
            const SizedBox(height: 12),
            Text(
              locale.auth_blocked_rejection_policy_reset_note,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                color: color.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BlockedMetricRow extends StatelessWidget {
  const _BlockedMetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size13,
              color: color.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size13,
            color: color.onSurface,
          ),
        ),
      ],
    );
  }
}
