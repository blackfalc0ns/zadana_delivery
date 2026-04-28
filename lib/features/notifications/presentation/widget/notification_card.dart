import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/features/notifications/domain/entities/driver_notification_entity.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.item,
    required this.isLoading,
    this.onTap,
  });

  final DriverNotificationEntity item;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final title = isArabic ? item.titleAr : item.titleEn;
    final body = isArabic ? item.bodyAr : item.bodyEn;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: isLoading ? null : onTap,
        child: Container(
          padding: const EdgeInsets.all(Spacing.base),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: item.isRead
                  ? AppColors.border
                  : AppColors.primary.withValues(alpha: 0.22),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _iconBackgroundColor(item.type),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  _iconForType(item.type),
                  color: _iconColor(item.type),
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title.trim().isEmpty ? item.type : title,
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size15,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: Spacing.sm),
                        if (isLoading)
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CustomProgressIndicator.compact(size: 18),
                          )
                        else if (!item.isRead)
                          Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      body.trim().isEmpty ? item.data : body,
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: Spacing.sm),
                    Row(
                      children: [
                        Text(
                          _formatDate(item.createdAt, context),
                          style: getMediumStyle(
                            fontFamily: FontConstant.cairo,
                            color: AppColors.primary,
                          ),
                        ),
                        if (!item.isRead) ...[
                          const SizedBox(width: Spacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              context.localization.notifications_unread_badge,
                              style: getSemiBoldStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size11,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (!item.isRead) ...[
                      const SizedBox(height: Spacing.sm),
                      AppButton.text(
                        text: context.localization.notifications_mark_as_read,
                        onPressed: isLoading ? null : onTap,
                        height: 36,
                        icon: Icons.done_rounded,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type.trim().toLowerCase()) {
      case 'driver-offer':
        return Icons.local_shipping_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }

  Color _iconColor(String type) {
    switch (type.trim().toLowerCase()) {
      case 'driver-offer':
        return AppColors.primary;
      default:
        return AppColors.secondary;
    }
  }

  Color _iconBackgroundColor(String type) {
    switch (type.trim().toLowerCase()) {
      case 'driver-offer':
        return const Color(0xFFE8F6F9);
      default:
        return const Color(0xFFFFF2E6);
    }
  }

  String _formatDate(DateTime date, BuildContext context) {
    final localeName = Localizations.localeOf(context).toLanguageTag();
    return DateFormat('d MMM, h:mm a', localeName).format(date);
  }
}
