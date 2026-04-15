import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final sections = isArabic
        ? const [
            (
              'جمع البيانات',
              'نقوم بجمع البيانات الأساسية اللازمة لإدارة الحساب، تنفيذ الطلبات، وتحسين تجربة الاستخدام داخل التطبيق.',
            ),
            (
              'استخدام البيانات',
              'تُستخدم بياناتك لتشغيل الخدمات، إرسال الإشعارات المهمة، وتحسين مستوى الدعم والتجربة اليومية.',
            ),
            (
              'مشاركة البيانات',
              'لا تتم مشاركة بياناتك إلا عند الحاجة لتقديم الخدمة مع الجهات المرتبطة مثل أنظمة الدفع أو الخدمات التشغيلية.',
            ),
            (
              'حماية الخصوصية',
              'نلتزم باتخاذ إجراءات مناسبة لحماية البيانات وتقليل الوصول غير المصرح به أو الاستخدام غير السليم.',
            ),
          ]
        : const [
            (
              'Data Collection',
              'We collect essential information required to manage accounts, process orders, and improve the app experience.',
            ),
            (
              'Data Usage',
              'Your data is used to operate services, send important notifications, and improve daily support quality.',
            ),
            (
              'Data Sharing',
              'Your data is only shared when needed to provide the service with connected providers such as payment or operational services.',
            ),
            (
              'Privacy Protection',
              'We take appropriate measures to protect personal data and reduce unauthorized access or misuse.',
            ),
          ];

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar.modern(
        title: locale.privacy_policy,
        backgroundColor: color.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Spacing.base,
          Spacing.base,
          Spacing.base,
          Spacing.xl,
        ),
        children: [
          _PrivacyHeader(isArabic: isArabic),
          const SizedBox(height: Spacing.xl),
          ...sections.map(
            (section) => Padding(
              padding: const EdgeInsets.only(bottom: Spacing.md),
              child: _PrivacySectionCard(title: section.$1, body: section.$2),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyHeader extends StatelessWidget {
  const _PrivacyHeader({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: color.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(Icons.privacy_tip_outlined, color: color.primary),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'التحكم في خصوصيتك' : 'Control your privacy',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size16,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isArabic
                      ? 'تعرف على كيفية جمع البيانات واستخدامها وحمايتها داخل التطبيق.'
                      : 'Learn how data is collected, used, and protected inside the app.',
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size13,
                    color: color.onSurfaceVariant,
                  ).copyWith(height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacySectionCard extends StatelessWidget {
  const _PrivacySectionCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.36)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size15,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            body,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size13,
              color: color.onSurfaceVariant,
            ).copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}
