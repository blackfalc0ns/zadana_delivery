import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';

class SupportHelpScreen extends StatelessWidget {
  const SupportHelpScreen({super.key});

  static const _email = 'support@zadana.com';
  static const _phone = '+201000000000';
  static const _whatsApp = '+201000000000';

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final color = context.colorScheme;

    final faqItems = isArabic
        ? const [
            (
              'كيف أتابع الطلبات الخاصة بي؟',
              'يمكنك متابعة حالة الطلبات من صفحة الطلبات ومعرفة كل تحديث جديد أولًا بأول.',
            ),
            (
              'ماذا أفعل إذا واجهت مشكلة أثناء التوصيل؟',
              'يمكنك التواصل مع فريق الدعم مباشرة وسنساعدك في حل المشكلة أو توجيهك للخطوات المناسبة.',
            ),
            (
              'كيف أتواصل مع الدعم بشكل أسرع؟',
              'أفضل طريقة سريعة هي واتساب أو الاتصال المباشر، ويمكنك أيضًا إرسال بريد إلكتروني بالتفاصيل.',
            ),
          ]
        : const [
            (
              'How can I track my orders?',
              'You can follow order status updates from the orders page and see the latest progress at any time.',
            ),
            (
              'What should I do if I face a delivery issue?',
              'You can reach support directly and we will help resolve the issue or guide you through the next steps.',
            ),
            (
              'What is the fastest way to contact support?',
              'WhatsApp or a direct phone call is usually the fastest option, and email is also available for detailed cases.',
            ),
          ];

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar.modern(
        title: locale.help_support,
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
          _HelpSupportHeader(isArabic: isArabic),
          const SizedBox(height: Spacing.xl),
          _SectionTitle(title: locale.contact_us),
          const SizedBox(height: Spacing.md),
          _ContactTile(
            icon: FontAwesomeIcons.listCheck,
            title: isArabic ? 'قضايا الدعم' : 'My cases',
            subtitle: isArabic
                ? 'راجع النزاعات والمشكلات السابقة'
                : 'Review your past disputes and issues',
            iconColor: const Color(0xFF7C4DFF),
            onTap: () => context.pushNamed(AppRoutes.driverSupportCases),
          ),
          const SizedBox(height: Spacing.sm),
          _ContactTile(
            icon: FontAwesomeIcons.whatsapp,
            title: 'WhatsApp',
            subtitle: isArabic
                ? 'تواصل سريع مع فريق الدعم'
                : 'Quick chat with the support team',
            iconColor: const Color(0xFF25D366),
            onTap: () => _launchExternal(
              'https://wa.me/${_whatsApp.replaceAll('+', '')}',
            ),
          ),
          const SizedBox(height: Spacing.sm),
          _ContactTile(
            icon: FontAwesomeIcons.envelope,
            title: 'Email',
            subtitle: _email,
            iconColor: const Color(0xFFEA4335),
            onTap: () => _launchExternal('mailto:$_email'),
          ),
          const SizedBox(height: Spacing.sm),
          _ContactTile(
            icon: FontAwesomeIcons.phoneVolume,
            title: isArabic ? 'الهاتف' : 'Phone',
            subtitle: _phone,
            iconColor: const Color(0xFF4285F4),
            onTap: () => _launchExternal('tel:$_phone'),
          ),
          const SizedBox(height: Spacing.xl),
          _SectionTitle(title: locale.faq),
          const SizedBox(height: Spacing.md),
          ...faqItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: Spacing.sm),
              child: _FaqTile(question: item.$1, answer: item.$2),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchExternal(String value) async {
    final uri = Uri.parse(value);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _HelpSupportHeader extends StatelessWidget {
  const _HelpSupportHeader({required this.isArabic});

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
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: color.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.support_agent_rounded,
              color: color.primary,
              size: 30,
            ),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            isArabic ? 'كيف يمكننا مساعدتك؟' : 'How can we help you?',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size18,
              color: color.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            isArabic
                ? 'تواصل معنا مباشرة أو راجع الأسئلة الشائعة للوصول إلى الحل بسرعة.'
                : 'Reach us directly or review the common questions to find the right answer quickly.',
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size13,
              color: color.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: getBoldStyle(
        fontFamily: FontConstant.cairo,
        fontSize: FontSize.size16,
        color: context.colorScheme.onSurface,
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.onTap,
  });

  final FaIconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(Spacing.base),
          decoration: BoxDecoration(
            color: color.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: color.outlineVariant.withValues(alpha: 0.40),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(child: FaIcon(icon, size: 18, color: iconColor)),
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
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.md),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: color.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.36)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: Spacing.base,
          vertical: Spacing.xs,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          Spacing.base,
          0,
          Spacing.base,
          Spacing.base,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(22)),
        ),
        collapsedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(22)),
        ),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.help_outline_rounded,
            size: 18,
            color: color.primary,
          ),
        ),
        title: Text(
          question,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: color.onSurface,
          ),
        ),
        iconColor: color.primary,
        collapsedIconColor: color.onSurfaceVariant,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              answer,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                color: color.onSurfaceVariant,
              ).copyWith(height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
