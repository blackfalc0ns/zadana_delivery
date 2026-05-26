import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/l10n/translations/app_localizations.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_entity.dart';

class DriverSupportCaseCard extends StatelessWidget {
  const DriverSupportCaseCard({
    super.key,
    required this.item,
    required this.isArabic,
    required this.onTap,
  });

  final DriverSupportCaseEntity item;
  final bool isArabic;
  final VoidCallback onTap;

  String _labelize(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return '--';
    return normalized
        .replaceAll('_', ' ')
        .replaceAllMapped(
          RegExp(r'([a-z])([A-Z])'),
          (match) => '${match.group(1)} ${match.group(2)}',
        );
  }

  String _localizedLabel({
    required String? ar,
    required String? en,
    required String fallback,
  }) {
    final preferred = isArabic ? ar : en;
    final normalized = preferred?.trim() ?? '';
    if (normalized.isNotEmpty) return normalized;
    return fallback;
  }

  String _caseTypeLabel(AppLocalizations locale) {
    final apiLabel = _localizedLabel(
      ar: item.typeLabelAr,
      en: item.typeLabelEn,
      fallback: '',
    );
    if (apiLabel.isNotEmpty) return apiLabel;
    switch (item.type.trim().toLowerCase()) {
      case 'driver_report':
      case 'driverreport':
        return locale.driver_support_case_type_report;
      case 'driver_dispute':
      case 'dispute':
        return locale.driver_support_case_type_dispute;
      case 'driver_account':
        return locale.driver_support_case_type_account;
      default:
        return _labelize(item.type);
    }
  }

  String _statusLabel(AppLocalizations locale) {
    final apiLabel = _localizedLabel(
      ar: item.statusLabelAr,
      en: item.statusLabelEn,
      fallback: '',
    );
    if (apiLabel.isNotEmpty) return apiLabel;
    switch (item.status.trim().toLowerCase()) {
      case 'submitted':
        return locale.driver_support_case_status_submitted;
      case 'in_review':
        return locale.driver_support_case_status_in_review;
      case 'awaiting_customer_evidence':
        return locale.driver_support_case_status_awaiting_evidence;
      case 'approved':
        return locale.driver_support_case_status_approved;
      case 'rejected':
        return locale.driver_support_case_status_rejected;
      case 'resolved':
        return locale.driver_support_case_status_resolved;
      default:
        return _labelize(item.status);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final scheme = context.colorScheme;
    final title = item.orderNumber.isEmpty ? item.id : item.orderNumber;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.14),
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: 0.025),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.hasOrderContext
                              ? locale.driver_support_case_order_number
                              : locale.driver_support_case_reference,
                          style: context.textTheme.labelLarge?.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _MetaPill(
                              icon: Icons.flag_rounded,
                              label: _statusLabel(locale),
                              foreground: scheme.primary,
                              background: scheme.primary.withValues(
                                alpha: 0.08,
                              ),
                            ),
                            _MetaPill(
                              icon: Icons.balance_rounded,
                              label: _caseTypeLabel(locale),
                              foreground: scheme.secondary,
                              background: scheme.secondary.withValues(
                                alpha: 0.08,
                              ),
                            ),
                            if (item.isAwaitingDriverResponse)
                              _MetaPill(
                                icon: Icons.reply_rounded,
                                label: isArabic
                                    ? 'مطلوب ردك'
                                    : 'Response needed',
                                foreground: const Color(0xFFD32F2F),
                                background: const Color(0xFFFFEBEE),
                              ),
                          ],
                        ),
                      ],
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
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.label,
    required this.foreground,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: foreground),
          const SizedBox(width: 4),
          Text(
            label,
            style: context.textTheme.labelLarge?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
