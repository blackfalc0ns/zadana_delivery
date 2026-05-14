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
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/auth/account_status/domain/entities/driver_account_status_entity.dart';
import 'package:zadana_delivery/features/auth/session/presentation/manager/auth_gate_cubit.dart';
import 'package:zadana_delivery/features/auth/session/presentation/manager/auth_gate_event.dart';
import 'package:zadana_delivery/features/auth/session/presentation/manager/auth_gate_state.dart';
import 'package:zadana_delivery/features/auth/session/presentation/widgets/auth_status_notification_button.dart';

class AccountPendingApprovalScreen extends StatefulWidget {
  const AccountPendingApprovalScreen({super.key, this.initialStatus});

  final DriverAccountStatusEntity? initialStatus;

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
              message: locale.profile_logout_success,
            );
            context.pushNamedAndRemoveUntil(
              AppRoutes.login,
              rootNavigator: true,
              predicate: (route) => false,
            );
          }
        },
        builder: (context, state) {
          final resolvedStatus = state.accountStatus ?? widget.initialStatus;
          final isArabic = Localizations.localeOf(context).languageCode == 'ar';
          final reviewMessage = _resolveReviewMessage(
            resolvedStatus,
            isArabic: isArabic,
          );
          final needsProfileUpdate = _needsProfileUpdate(
            status: resolvedStatus,
            reviewMessage: reviewMessage,
          );

          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Positioned(
                  top: -40,
                  right: isArabic ? null : -30,
                  left: isArabic ? -30 : null,
                  child: _SoftOrb(
                    size: 150,
                    color: AppColors.primary.withValues(alpha: 0.08),
                  ),
                ),
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
                                onTap: () =>
                                    context.pushNamed(AppRoutes.notifications),
                              ),
                            ],
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  const SizedBox(height: Spacing.sm),
                                  const _PendingHero(),
                                  const SizedBox(height: Spacing.md),
                                  _StatusPill(
                                    text: needsProfileUpdate
                                        ? locale.auth_pending_update_required
                                        : locale
                                              .auth_pending_under_review_badge,
                                  ),
                                  const SizedBox(height: Spacing.md),
                                  Text(
                                    locale.auth_pending_title,
                                    textAlign: TextAlign.center,
                                    style: getBoldStyle(
                                      fontFamily: FontConstant.cairo,
                                      fontSize: FontSize.size24,
                                      color: color.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: Spacing.xs),
                                  Text(
                                    needsProfileUpdate
                                        ? locale
                                              .auth_pending_update_short_description
                                        : locale
                                              .auth_pending_review_short_description,
                                    textAlign: TextAlign.center,
                                    style: getRegularStyle(
                                      fontFamily: FontConstant.cairo,
                                      fontSize: FontSize.size14,
                                      color: color.onSurfaceVariant,
                                    ),
                                  ),
                                  if (reviewMessage.isNotEmpty) ...[
                                    const SizedBox(height: Spacing.md),
                                    _InfoCard(
                                      icon: Icons.info_outline_rounded,
                                      title: locale.auth_pending_note_title,
                                      message: reviewMessage,
                                      tint: AppColors.secondary,
                                      background: AppColors.secondary
                                          .withValues(alpha: 0.08),
                                    ),
                                  ],
                                  const SizedBox(height: Spacing.md),
                                  _InfoCard(
                                    icon: Icons.notifications_active_rounded,
                                    title:
                                        locale.auth_pending_notifications_title,
                                    message: needsProfileUpdate
                                        ? locale
                                              .auth_pending_notifications_update_message
                                        : locale
                                              .auth_pending_notifications_review_message,
                                    tint: AppColors.primary,
                                    background: color.surfaceContainerLow,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: Spacing.md),
                          AppButton.filled(
                            text: needsProfileUpdate
                                ? locale.auth_pending_update_details
                                : locale.auth_pending_update_details,
                            onPressed: () => context.pushNamed(
                              AppRoutes.driverProfileCompletion,
                            ),
                            color: needsProfileUpdate
                                ? AppColors.secondary
                                : AppColors.primary,
                            height: 54,
                            borderRadius: 18,
                          ),
                          const SizedBox(height: Spacing.sm),
                          AppButton.outlined(
                            text: locale.auth_logout_account,
                            onPressed: () => _cubit.doIntent(
                              const AuthGateLogoutRequestedEvent(),
                            ),
                            color: color.error,
                            textColor: color.error,
                            height: 50,
                            borderRadius: 18,
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

  bool _needsProfileUpdate({
    required DriverAccountStatusEntity? status,
    required String reviewMessage,
  }) {
    final normalizedReview = reviewMessage.trim().toLowerCase();
    final normalizedVerification = status?.normalizedVerificationStatus ?? '';

    if (normalizedVerification == 'needsdocuments') {
      return true;
    }

    return [
      'تعديل',
      'رفع',
      'صوره',
      'صورة',
      'مستند',
      'بيانات',
      'document',
      'photo',
      'image',
      'upload',
      'update',
      'edit',
      'resubmit',
    ].any(normalizedReview.contains);
  }

  String _resolveReviewMessage(
    DriverAccountStatusEntity? status, {
    required bool isArabic,
  }) {
    if (status == null) return '';

    for (final candidate in [
      if (isArabic) status.reviewNoteAr else status.reviewNoteEn,
      status.reviewNote,
      if (isArabic) status.messageAr else status.messageEn,
      if (isArabic)
        status.restrictionMessageAr
      else
        status.restrictionMessageEn,
      status.restrictionMessage,
      status.message,
      status.suspensionReason,
    ]) {
      final normalized = candidate?.trim() ?? '';
      if (normalized.isNotEmpty) {
        return normalized;
      }
    }

    return '';
  }
}

class _PendingHero extends StatelessWidget {
  const _PendingHero();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 178,
            height: 178,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.05),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: Lottie.asset(Assets.blueLoading),
              ),
              const SizedBox(height: Spacing.xs),
              SizedBox(
                height: 86,
                child: SvgPicture.asset(Assets.fastDelivery),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size13,
          color: color.onSurface,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.tint,
    required this.background,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color tint;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: tint.withValues(alpha: 0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: tint),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size14,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size13,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftOrb extends StatelessWidget {
  const _SoftOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
