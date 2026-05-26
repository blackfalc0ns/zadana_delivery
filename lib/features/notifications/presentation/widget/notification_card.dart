import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
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
    final isUnread = !item.isRead;
    final iconColor = _iconColor(item.type);
    final iconBackground = _iconBackgroundColor(item.type);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: isLoading ? null : onTap,
        child: Container(
          padding: const EdgeInsets.all(Spacing.base),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
            border: Border.all(
              color: isUnread
                  ? AppColors.primary.withValues(alpha: 0.16)
                  : const Color(0xFFE5EDF2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconBackground,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(_iconForType(item.type), color: iconColor),
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
                            if (isUnread) ...[
                              const SizedBox(width: Spacing.sm),
                              Container(
                                width: 11,
                                height: 11,
                                margin: const EdgeInsets.only(top: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.28,
                                      ),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.sm),
              Wrap(
                spacing: Spacing.sm,
                runSpacing: Spacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: iconBackground,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: iconColor,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          _formatDate(item.createdAt, context),
                          style: getMediumStyle(
                            fontFamily: FontConstant.cairo,
                            color: iconColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isUnread)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
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
