import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: CustomAppBar.modern(
        title: 'الخصوصية',
        backgroundColor: const Color(0xFFF7FAFC),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.base),
        children: const [
          _PrivacyHero(),
          SizedBox(height: Spacing.md),
          _PrivacyTile(
            title: 'البيانات الظاهرة',
            subtitle: 'إدارة ما يتم عرضه من معلومات حسابك داخل التطبيق.',
          ),
          SizedBox(height: Spacing.sm),
          _PrivacyTile(
            title: 'سياسة الخصوصية',
            subtitle: 'مراجعة كيفية استخدام البيانات وتخزينها ومعالجتها.',
          ),
          SizedBox(height: Spacing.sm),
          _PrivacyTile(
            title: 'مشاركة البيانات',
            subtitle: 'ضبط تفضيلات مشاركة معلومات الحساب مع الخدمات المختلفة.',
          ),
        ],
      ),
    );
  }
}

class _PrivacyHero extends StatelessWidget {
  const _PrivacyHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.privacy_tip_outlined, color: AppColors.info),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'التحكم في الخصوصية',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size16,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'واجهة UI جاهزة لتوصيل إعدادات الخصوصية الحقيقية لاحقًا.',
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
    );
  }
}

class _PrivacyTile extends StatelessWidget {
  const _PrivacyTile({required this.title, required this.subtitle});

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
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
