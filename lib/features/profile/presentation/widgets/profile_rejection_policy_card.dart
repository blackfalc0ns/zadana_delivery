import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/l10n/translations/app_localizations.dart';
import 'package:zadana_delivery/features/profile/domain/entities/driver_rejection_policy_entity.dart';

class ProfileRejectionPolicyCard extends StatelessWidget {
  const ProfileRejectionPolicyCard({super.key, required this.policy});

  final DriverRejectionPolicyEntity policy;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final accent = policy.isFrozen ? color.error : AppColors.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color.surface,
        border: Border.all(
          color: policy.isFrozen
              ? accent.withValues(alpha: 0.18)
              : color.outlineVariant.withValues(alpha: 0.28),
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.045),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(policy: policy, accent: accent),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PolicyMetricPanel(
                  accent: accent,
                  icon: Icons.today_rounded,
                  label: locale.profile_rejection_today_label,
                  value: policy.dailyRejections,
                  limit: policy.dailyLimit,
                  remainingLabel:
                      locale.profile_rejection_today_remaining_label,
                  remainingValue: policy.remainingBeforeFreeze,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: _PolicyMetricPanel(
                  accent: policy.isFrozen ? accent : AppColors.secondary,
                  icon: Icons.date_range_rounded,
                  label: locale.profile_rejection_week_label,
                  value: policy.weeklyRejections,
                  limit: policy.weeklyLimit,
                  remainingLabel: locale.profile_rejection_week_remaining_label,
                  remainingValue: policy.remainingBeforeWeeklyFreeze,
                ),
              ),
            ],
          ),
          if ((policy.restrictionMessage ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: Spacing.sm),
            _InlineNote(
              icon: policy.isFrozen
                  ? Icons.gpp_maybe_rounded
                  : Icons.info_outline_rounded,
              tint: accent,
              message: policy.restrictionMessage!,
            ),
          ],
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.policy, required this.accent});

  final DriverRejectionPolicyEntity policy;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: accent.withValues(alpha: 0.14)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                policy.isFrozen ? Icons.block_rounded : Icons.verified_outlined,
                size: 16,
                color: accent,
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                _statusText(locale),
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size10,
                  color: accent,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                locale.profile_rejection_policy_title,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size18,
                  color: color.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 1),
              Text(
                _summaryText(locale),
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size10,
                  color: color.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _statusText(AppLocalizations locale) {
    return policy.isFrozen
        ? locale.profile_rejection_policy_status_frozen
        : locale.profile_rejection_policy_status_active;
  }

  String _summaryText(AppLocalizations locale) {
    return policy.isFrozen
        ? locale.profile_rejection_policy_summary_frozen
        : locale.profile_rejection_policy_summary_active;
  }
}

class _PolicyMetricPanel extends StatelessWidget {
  const _PolicyMetricPanel({
    required this.accent,
    required this.icon,
    required this.label,
    required this.value,
    required this.limit,
    required this.remainingLabel,
    required this.remainingValue,
  });

  final Color accent;
  final IconData icon;
  final String label;
  final int value;
  final int limit;
  final String remainingLabel;
  final int remainingValue;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final safeLimit = math.max(limit, 0);
    final safeValue = math.max(value, 0);
    final progress = safeLimit == 0
        ? 0.0
        : (safeValue / safeLimit).clamp(0.0, 1.0);
    final remainingAccent = remainingValue <= 1
        ? color.error
        : remainingValue <= 3
        ? AppColors.secondary
        : accent;

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size11,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            '$safeValue/$safeLimit',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size18,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: accent.withValues(alpha: 0.10),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 0.8
                    ? color.error
                    : progress >= 0.55
                    ? AppColors.secondary
                    : accent,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  remainingLabel,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size10,
                    color: color.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                '$remainingValue',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size10,
                  color: remainingAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InlineNote extends StatelessWidget {
  const _InlineNote({
    required this.icon,
    required this.tint,
    required this.message,
  });

  final IconData icon;
  final Color tint;
  final String message;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 13, color: tint),
          ),
          const SizedBox(width: Spacing.xs),
          Expanded(
            child: Text(
              message,
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size11,
                color: color.onSurface,
              ).copyWith(height: 1.35),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
