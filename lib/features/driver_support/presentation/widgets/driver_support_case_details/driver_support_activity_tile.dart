import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/l10n/translations/app_localizations.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_activity_entity.dart';

class DriverSupportActivityTile extends StatelessWidget {
  const DriverSupportActivityTile({
    super.key,
    required this.isArabic,
    required this.activity,
  });

  final bool isArabic;
  final DriverSupportCaseActivityEntity activity;

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

  String _activityLabel(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final titleLabel = _localizedLabel(
      ar: activity.titleAr,
      en: activity.titleEn,
      fallback: '',
    );
    if (titleLabel.isNotEmpty) return titleLabel;

    final actionLabel = _localizedLabel(
      ar: activity.typeLabelAr,
      en: activity.typeLabelEn,
      fallback: '',
    );
    if (actionLabel.isNotEmpty) return actionLabel;
    switch (activity.type.trim().toLowerCase()) {
      case 'submitted':
        return locale.driver_support_activity_case_opened;
      case 'follow_up':
        return locale.driver_support_activity_follow_up_added;
      case 'driver_response':
        return locale.driver_support_activity_driver_replied;
      default:
        return _labelize(activity.type);
    }
  }

  String? _actorLabel() {
    final value = _localizedLabel(
      ar: activity.actorRoleLabelAr,
      en: activity.actorRoleLabelEn,
      fallback: activity.actorName?.trim() ?? '',
    );
    return value.trim().isEmpty ? null : value;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final actorLabel = _actorLabel();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: scheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _activityLabel(context),
                  style: context.textTheme.labelLarge?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (activity.message.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    activity.message.trim(),
                    style: context.textTheme.bodyMedium?.copyWith(
                      height: 1.3,
                      fontSize: 13.5,
                    ),
                  ),
                ],
                if (actorLabel != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    actorLabel,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: scheme.primary.withValues(alpha: 0.84),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  _formatDate(activity.createdAt),
                  style: context.textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
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
