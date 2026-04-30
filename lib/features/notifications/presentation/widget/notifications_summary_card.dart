import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class NotificationsSummaryCard extends StatelessWidget {
  const NotificationsSummaryCard({
    super.key,
    required this.unreadCount,
    required this.totalCount,
  });

  final int unreadCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final hasUnread = unreadCount > 0;

    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5EDF2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: hasUnread
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : AppColors.successLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              hasUnread
                  ? Icons.notifications_active_rounded
                  : Icons.done_all_rounded,
              color: hasUnread ? AppColors.primary : AppColors.success,
              size: 24,
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasUnread
                      ? locale.notifications_unread_summary(unreadCount)
                      : locale.notifications_all_caught_up,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size16,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  locale.notifications_total_summary(totalCount),
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  hasUnread ? 'تحتاج متابعة' : 'كل شيء محدث',
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    color: hasUnread ? AppColors.secondary : AppColors.success,
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
