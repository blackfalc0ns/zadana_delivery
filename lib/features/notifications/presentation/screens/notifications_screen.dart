import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const List<_NotificationItemData> _items = [
    _NotificationItemData(
      title: 'تم استلام طلب انضمامك',
      body: 'فريق زدانا يراجع بياناتك الآن، وسنرسل لك تحديثًا فور الانتهاء.',
      time: 'الآن',
      icon: Icons.mark_email_unread_rounded,
      iconColor: AppColors.primary,
      backgroundColor: Color(0xFFE8F6F9),
      isUnread: true,
    ),
    _NotificationItemData(
      title: 'تأكد من متابعة حالة الحساب',
      body: 'يمكنك الرجوع لهذه الصفحة في أي وقت لمعرفة آخر إشعارات التفعيل.',
      time: 'منذ 10 دقائق',
      icon: Icons.verified_user_outlined,
      iconColor: AppColors.secondary,
      backgroundColor: Color(0xFFFFF2E6),
    ),
    _NotificationItemData(
      title: 'نصائح قبل بدء العمل',
      body: 'جهز بيانات المركبة والمستندات المطلوبة لتسريع تفعيل الحساب.',
      time: 'أمس',
      icon: Icons.two_wheeler_rounded,
      iconColor: AppColors.info,
      backgroundColor: Color(0xFFEAF4FF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: CustomAppBar.modern(
        title: 'الإشعارات',
        backgroundColor: const Color(0xFFF7FAFC),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            Spacing.base,
            Spacing.base,
            Spacing.base,
            Spacing.xl,
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(Spacing.base),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.08),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.notifications_active_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'لديك إشعار غير مقروء',
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: Spacing.xs),
                        Text(
                          'هذه الشاشة UI فقط حاليًا، وتم تجهيزها لربط البيانات لاحقًا.',
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
            ),
            const SizedBox(height: Spacing.lg),
            ..._items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: Spacing.md),
                child: _NotificationCard(item: item),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item});

  final _NotificationItemData item;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          color: item.isUnread
              ? AppColors.primary.withValues(alpha: 0.22)
              : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: item.backgroundColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(item.icon, color: item.iconColor),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (item.isUnread)
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  item.body,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  item.time,
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    color: AppColors.primary,
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

class _NotificationItemData {
  const _NotificationItemData({
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.isUnread = false,
  });

  final String title;
  final String body;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final bool isUnread;
}
