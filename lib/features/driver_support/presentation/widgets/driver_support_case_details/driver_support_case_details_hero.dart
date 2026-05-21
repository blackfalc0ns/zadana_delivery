import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/l10n/translations/app_localizations.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_entity.dart';

class DriverSupportCaseDetailsHero extends StatelessWidget {
  const DriverSupportCaseDetailsHero({
    super.key,
    required this.item,
    required this.isArabic,
  });

  final DriverSupportCaseEntity item;
  final bool isArabic;

  String _formatDate(DateTime? value) {
    if (value == null) return '--';
    return DateFormat('dd/MM/yyyy - hh:mm a').format(value.toLocal());
  }

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

  String _priorityLabel(AppLocalizations locale) {
    final apiLabel = _localizedLabel(
      ar: item.priorityLabelAr,
      en: item.priorityLabelEn,
      fallback: '',
    );
    if (apiLabel.isNotEmpty) return apiLabel;
    switch (item.priority.trim().toLowerCase()) {
      case 'low':
        return locale.driver_support_case_priority_low;
      case 'medium':
        return locale.driver_support_case_priority_medium;
      case 'high':
        return locale.driver_support_case_priority_high;
      case 'critical':
      case 'urgent':
        return locale.driver_support_case_priority_critical;
      default:
        return _labelize(item.priority);
    }
  }

  String _reasonLabel(AppLocalizations locale) {
    final apiLabel = _localizedLabel(
      ar: item.reasonLabelAr,
      en: item.reasonLabelEn,
      fallback: '',
    );
    if (apiLabel.isNotEmpty) return apiLabel;
    switch (item.reasonCode.trim().toLowerCase()) {
      case 'customer_unavailable':
      case 'customer_unreachable':
        return locale.driver_support_reason_customer_unavailable;
      case 'wrong_address':
        return locale.driver_support_reason_wrong_address;
      case 'payment_issue':
      case 'payout_dispute':
        return locale.driver_support_reason_payout_issue;
      case 'damaged_package':
      case 'order_damaged':
        return locale.driver_support_reason_damaged_package;
      default:
        return _labelize(item.reasonCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final scheme = context.colorScheme;
    final title = item.orderNumber.isEmpty ? item.id : item.orderNumber;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final infoCardWidth = math.max((screenWidth - 46) / 2, 132.0);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary.withValues(alpha: 0.03),
            scheme.tertiary.withValues(alpha: 0.012),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.14),
        ),
      ),
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
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 21,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _HeroPill(
                icon: Icons.balance_rounded,
                label: _caseTypeLabel(locale),
                color: scheme.tertiary,
              ),
              _HeroPill(
                icon: Icons.flag_rounded,
                label: _statusLabel(locale),
                color: scheme.primary,
              ),
              _HeroPill(
                icon: Icons.priority_high_rounded,
                label: _priorityLabel(locale),
                color: scheme.secondary,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SizedBox(
                width: infoCardWidth,
                child: _HeroInfoLine(
                  label: locale.driver_support_case_reason,
                  value: _reasonLabel(locale),
                ),
              ),
              SizedBox(
                width: infoCardWidth,
                child: _HeroInfoLine(
                  label: locale.driver_support_case_last_update,
                  value: _formatDate(item.updatedAt ?? item.createdAt),
                ),
              ),
              if ((item.queue ?? '').trim().isNotEmpty)
                SizedBox(
                  width: infoCardWidth,
                  child: _HeroInfoLine(
                    label: locale.driver_support_case_queue,
                    value: _localizedLabel(
                      ar: item.queueLabelAr,
                      en: item.queueLabelEn,
                      fallback: item.queue!.trim(),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: context.textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroInfoLine extends StatelessWidget {
  const _HeroInfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: scheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
