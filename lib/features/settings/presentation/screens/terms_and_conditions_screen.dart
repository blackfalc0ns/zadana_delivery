import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  static const _arabicAsset =
      'assets/documents/driver_terms_and_conditions_ar.md';
  static const _englishAsset =
      'assets/documents/driver_terms_and_conditions_en.md';

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final asset = isArabic ? _arabicAsset : _englishAsset;
    final textDirection = isArabic ? TextDirection.rtl : TextDirection.ltr;

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: CustomAppBar.modern(
        title: context.localization.terms_conditions,
        backgroundColor: context.colorScheme.surface,
      ),
      body: FutureBuilder<String>(
        future: rootBundle.loadString(asset),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return _TermsLoadError(isArabic: isArabic);
          }
          return _TermsDocument(
            document: snapshot.data!,
            textDirection: textDirection,
          );
        },
      ),
    );
  }
}

class _TermsDocument extends StatelessWidget {
  const _TermsDocument({required this.document, required this.textDirection});

  final String document;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final lines = document.split(RegExp(r'\r?\n'));

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        Spacing.base,
        Spacing.base,
        Spacing.base,
        Spacing.xl,
      ),
      itemCount: lines.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final line = lines[index].trim();
        if (line.isEmpty) return const SizedBox.shrink();
        final isTitle = line.startsWith('# ');
        final isHeading = line.startsWith('## ');
        final content = line.replaceFirst(RegExp(r'^#{1,2}\s+'), '');
        final isMeta =
            content.startsWith('**Version:') ||
            content.startsWith('**الإصدار:') ||
            content.startsWith('**Effective') ||
            content.startsWith('**تاريخ');

        if (isTitle) {
          return Container(
            padding: const EdgeInsets.all(Spacing.lg),
            decoration: BoxDecoration(
              color: color.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              content,
              textDirection: textDirection,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size20,
                color: color.onSurface,
              ).copyWith(height: 1.45),
            ),
          );
        }
        if (isHeading) {
          return Padding(
            padding: const EdgeInsets.only(top: Spacing.md),
            child: Text(
              content,
              textDirection: textDirection,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size16,
                color: color.primary,
              ),
            ),
          );
        }
        return Text(
          content.replaceAll('**', '').replaceFirst(RegExp(r'^[-*]\s+'), '• '),
          textDirection: textDirection,
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: isMeta ? FontSize.size12 : FontSize.size14,
            color: isMeta ? color.onSurfaceVariant : color.onSurface,
          ).copyWith(height: 1.8),
        );
      },
    );
  }
}

class _TermsLoadError extends StatelessWidget {
  const _TermsLoadError({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xl),
        child: Text(
          isArabic
              ? 'تعذر تحميل الشروط والأحكام. حاول مرة أخرى.'
              : 'Unable to load the terms and conditions. Please try again.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
