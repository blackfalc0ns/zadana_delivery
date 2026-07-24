import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/features/settings/data/public_content_service.dart';
import 'package:zadana_delivery/features/settings/presentation/widgets/public_content_shimmer.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});
  @override
  Widget build(BuildContext context) => LegalScreen(
    title: context.localization.terms_conditions,
    type: 'DriverTerms',
  );
}

class LegalScreen extends StatefulWidget {
  const LegalScreen({super.key, required this.title, required this.type});
  final String title, type;
  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen> {
  late Future<LegalDocument> _future;
  @override
  void initState() {
    super.initState();
    _future = PublicContentService.instance.getLegal(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    final ar = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      appBar: CustomAppBar.modern(
        title: widget.title,
        backgroundColor: context.colorScheme.surface,
      ),
      body: FutureBuilder<LegalDocument>(
        future: _future,
        builder: (_, s) {
          if (s.connectionState != ConnectionState.done)
            return const PublicContentShimmer(rows: 7);
          if (s.hasError)
            return Center(
              child: TextButton(
                onPressed: () => setState(
                  () => _future = PublicContentService.instance.getLegal(
                    widget.type,
                  ),
                ),
                child: Text(
                  ar ? 'تعذر التحميل، أعد المحاولة' : 'Unable to load. Retry',
                ),
              ),
            );
          final d = s.data!;
          final content = d.contentFor(ar);
          if (content.isEmpty)
            return Center(
              child: Text(
                ar
                    ? 'المحتوى غير متاح حالياً.'
                    : 'Content is currently unavailable.',
              ),
            );
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _MarkdownText(content: content, rtl: ar),
              if (d.version.isNotEmpty || d.effectiveAtUtc != null)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Text(
                    '${d.version.isEmpty ? '' : 'v${d.version}'}${d.version.isNotEmpty && d.effectiveAtUtc != null ? ' • ' : ''}${d.effectiveAtUtc?.toLocal().toString().split(' ').first ?? ''}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _MarkdownText extends StatelessWidget {
  const _MarkdownText({required this.content, required this.rtl});
  final String content;
  final bool rtl;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: content
        .split(RegExp(r'\r?\n'))
        .where((line) => line.trim().isNotEmpty)
        .map((line) {
          final heading = line.startsWith('#');
          final text = line
              .replaceFirst(RegExp(r'^#+\s*'), '')
              .replaceAll('**', '')
              .replaceFirst(RegExp(r'^[-*]\s+'), '• ');
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              text,
              textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
              style: heading
                  ? Theme.of(context).textTheme.titleMedium
                  : Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.7),
            ),
          );
        })
        .toList(),
  );
}
