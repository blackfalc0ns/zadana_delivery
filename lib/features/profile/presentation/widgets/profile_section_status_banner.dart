import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/domain/entities/driver_profile_section_entity.dart';

class ProfileSectionStatusBanner extends StatelessWidget {
  const ProfileSectionStatusBanner({
    super.key,
    required this.section,
  });

  final DriverProfileSectionEntity section;

  @override
  Widget build(BuildContext context) {
    if (section.isValid) return const SizedBox.shrink();

    final l10n = context.localization;

    if (section.isUnderReview) {
      return _Banner(
        icon: Icons.hourglass_top_rounded,
        iconColor: AppColors.primary,
        backgroundColor: AppColors.primary.withValues(alpha: 0.08),
        borderColor: AppColors.primary.withValues(alpha: 0.20),
        title: l10n.profile_section_under_review_title,
        subtitle: l10n.profile_section_under_review_subtitle,
      );
    }

    if (section.isRejected) {
      final reason = section.rejectionReason;
      return _Banner(
        icon: Icons.error_outline_rounded,
        iconColor: Colors.red.shade700,
        backgroundColor: Colors.red.shade50,
        borderColor: Colors.red.shade200,
        title: l10n.profile_section_rejected_title,
        subtitle: reason?.isNotEmpty == true
            ? reason!
            : l10n.profile_section_rejected_default_subtitle,
      );
    }

    return const SizedBox.shrink();
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size14,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size12,
                    color: iconColor.withValues(alpha: 0.85),
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
