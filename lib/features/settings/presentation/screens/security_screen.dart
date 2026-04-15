import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: CustomAppBar.modern(
        title: 'الأمان',
        backgroundColor: const Color(0xFFF7FAFC),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.base),
        children: const [
          _SecurityHeader(),
          SizedBox(height: Spacing.md),
          _SecurityItem(
            icon: Icons.lock_outline_rounded,
            title: 'كلمة المرور',
            subtitle: 'تحديث كلمة المرور وإدارة صلاحية الوصول إلى الحساب.',
          ),
          SizedBox(height: Spacing.sm),
          _SecurityItem(
            icon: Icons.verified_user_outlined,
            title: 'التحقق من الهوية',
            subtitle: 'مراجعة حالة التحقق وإضافة خطوات حماية إضافية.',
          ),
          SizedBox(height: Spacing.sm),
          _SecurityItem(
            icon: Icons.devices_outlined,
            title: 'الأجهزة المسجلة',
            subtitle: 'عرض الأجهزة والجلسات المرتبطة بحسابك.',
          ),
        ],
      ),
    );
  }
}

class _SecurityHeader extends StatelessWidget {
  const _SecurityHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.shield_outlined, color: AppColors.success),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            'حماية الحساب',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size18,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'هذه شاشة UI لمتابعة الأمان وإعدادات الحماية وربطها لاحقًا بالخدمات الفعلية.',
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityItem extends StatelessWidget {
  const _SecurityItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.success),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    color: AppColors.textSecondary,
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
