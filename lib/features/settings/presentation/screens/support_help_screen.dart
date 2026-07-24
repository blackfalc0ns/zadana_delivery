import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/features/settings/data/public_content_service.dart';
import 'package:zadana_delivery/features/settings/presentation/widgets/public_content_shimmer.dart';

class SupportHelpScreen extends StatefulWidget {
  const SupportHelpScreen({super.key});

  @override
  State<SupportHelpScreen> createState() => _SupportHelpScreenState();
}

class _SupportHelpScreenState extends State<SupportHelpScreen> {
  late Future<PlatformContact> _future;

  @override
  void initState() {
    super.initState();
    _future = PublicContentService.instance.getContact();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      appBar: CustomAppBar.modern(
        title: context.localization.help_support,
        backgroundColor: context.colorScheme.surface,
      ),
      body: FutureBuilder<PlatformContact>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const PublicContentShimmer();
          }
          if (snapshot.hasError) {
            return _Message(
              text: isArabic
                  ? 'تعذر تحميل بيانات التواصل. حاول مرة أخرى.'
                  : 'Unable to load contact details. Please try again.',
              retry: () => setState(
                () => _future = PublicContentService.instance.getContact(),
              ),
            );
          }

          final contact = snapshot.data!;
          final contacts = <_ContactData>[
            if ((contact.whatsAppUrl ?? '').isNotEmpty)
              _ContactData(
                title: isArabic ? 'واتساب' : 'WhatsApp',
                value: _whatsAppValue(contact.whatsAppUrl!),
                url: contact.whatsAppUrl!,
                icon: FontAwesomeIcons.whatsapp,
                color: const Color(0xff25D366),
              ),
            if ((contact.supportEmail ?? '').isNotEmpty)
              _ContactData(
                title: isArabic ? 'الإيميل' : 'Email',
                value: contact.supportEmail!,
                url: 'mailto:${contact.supportEmail}',
                icon: FontAwesomeIcons.envelope,
                color: const Color(0xffEA4335),
              ),
            if ((contact.supportPhone ?? '').isNotEmpty)
              _ContactData(
                title: isArabic ? 'رقم الجوال' : 'Phone',
                value: contact.supportPhone!,
                url: 'tel:${contact.supportPhone}',
                icon: FontAwesomeIcons.phone,
                color: const Color(0xff4285F4),
              ),
          ];

          if (contacts.isEmpty) {
            return _Message(
              text: isArabic
                  ? 'بيانات التواصل غير متاحة حاليًا.'
                  : 'Contact details are currently unavailable.',
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            children: [
              const Icon(Icons.support_agent_rounded, size: 52),
              const SizedBox(height: 12),
              Text(
                isArabic ? 'كيف يمكننا مساعدتك؟' : 'How can we help?',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                isArabic
                    ? 'كلمنا وبنرد عليك قريب.'
                    : 'Contact us and we will get back to you soon.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 28),
              Text(
                isArabic ? 'كلمنا' : 'Contact us',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ...contacts.map(
                (contact) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ContactTile(data: contact),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ContactData {
  const _ContactData({
    required this.title,
    required this.value,
    required this.url,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final String url;
  final FaIconData icon;
  final Color color;
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.data});

  final _ContactData data;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: () => _launch(data.url),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: data.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: FaIcon(data.icon, color: data.color)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.value,
                      textDirection: TextDirection.ltr,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.arrow_forward_ios_rounded, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.retry});

  final String text;
  final VoidCallback? retry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, textAlign: TextAlign.center),
          if (retry != null)
            TextButton(onPressed: retry, child: const Text('Retry')),
        ],
      ),
    ),
  );
}

String _whatsAppValue(String value) {
  final uri = Uri.tryParse(value);
  if (uri == null) return value;
  return uri.pathSegments.isEmpty ? value : uri.pathSegments.last;
}

Future<void> _launch(String url) async {
  final uri = Uri.tryParse(url);
  if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
}
