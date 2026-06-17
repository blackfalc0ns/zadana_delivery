import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/domain/entities/driver_compliance_document_entity.dart';

/// Shows a compact banner when documents are under review or rejected.
class ProfileDocumentStatusBanner extends StatelessWidget {
  const ProfileDocumentStatusBanner({
    super.key,
    required this.documents,
    required this.onTap,
  });

  final List<DriverComplianceDocumentEntity> documents;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasRejected = documents.any((d) => d.isRejected);
    final hasReview = documents.any((d) => d.isReview);
    final hasExpiring = documents.any((d) => d.isExpiring);

    if (!hasRejected && !hasReview && !hasExpiring) {
      return const SizedBox.shrink();
    }

    final locale = context.localization;
    final colorScheme = context.colorScheme;

    final (icon, label, tint, bgColor) = _resolve(
      locale: locale,
      colorScheme: colorScheme,
      hasRejected: hasRejected,
      hasExpiring: hasExpiring,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: tint.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: tint),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.cairo,
                  color: tint,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: tint.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }

  (IconData, String, Color, Color) _resolve({
    required dynamic locale,
    required ColorScheme colorScheme,
    required bool hasRejected,
    required bool hasExpiring,
  }) {
    if (hasRejected) {
      return (
        Icons.warning_amber_rounded,
        locale.driver_account_status_document_rejected_banner,
        colorScheme.error,
        colorScheme.error.withValues(alpha: 0.08),
      );
    }
    if (hasExpiring) {
      return (
        Icons.schedule_rounded,
        locale.driver_account_status_document_expiring,
        Colors.orange.shade800,
        Colors.orange.withValues(alpha: 0.08),
      );
    }
    // Under review
    return (
      Icons.hourglass_top_rounded,
      locale.driver_account_status_document_review,
      Colors.amber.shade800,
      Colors.amber.withValues(alpha: 0.08),
    );
  }
}
