import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/domain/entities/driver_compliance_document_entity.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_document_item_data.dart';

class SecurityDocumentTile extends StatelessWidget {
  const SecurityDocumentTile({
    super.key,
    required this.item,
    required this.onTap,
    required this.onPreview,
  });

  final ProfileDocumentItemData item;
  final VoidCallback onTap;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final colorScheme = context.colorScheme;
    final fileName = item.hasFile
        ? item.path.split(RegExp(r'[/\\]')).last
        : locale.profile_not_uploaded_yet;
    final complianceDoc = item.complianceDocument;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: complianceDoc?.isRejected == true
            ? onTap
            : (item.hasFile ? onPreview : onTap),
        child: Container(
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: complianceDoc != null
                ? Border.all(
                    color: _statusBorderColor(complianceDoc, colorScheme),
                    width: 1.2,
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: colorScheme.primary),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.type.localizedTitle(locale),
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size13,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          fileName,
                          style: getRegularStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size11,
                            color: item.hasFile
                                ? colorScheme.onSurfaceVariant
                                : colorScheme.error,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (complianceDoc != null) ...[
                    const SizedBox(width: Spacing.xs),
                    _DocumentStatusBadge(document: complianceDoc),
                    const SizedBox(width: Spacing.xs),
                    TextButton(
                      onPressed: onTap,
                      child: Text(
                        item.hasFile
                            ? locale.change_address
                            : locale.driver_upload_status_upload,
                      ),
                    ),
                  ] else
                    TextButton(
                      onPressed: onTap,
                      child: Text(
                        item.hasFile
                            ? locale.change_address
                            : locale.driver_upload_status_upload,
                      ),
                    ),
                ],
              ),
              // Rejection reason banner
              if (complianceDoc?.isRejected == true &&
                  (complianceDoc!.rejectionReason ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: Spacing.sm),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 18,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          complianceDoc.rejectionReason!,
                          style: getRegularStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size11,
                            color: colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.upload_file_rounded, size: 18),
                    label: Text(locale.driver_upload_status_upload),
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.error,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ],
              // Review pending banner
              if (complianceDoc?.isReview == true) ...[
                const SizedBox(height: Spacing.sm),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.hourglass_top_rounded,
                        size: 18,
                        color: Colors.amber.shade800,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          locale.driver_account_status_document_review,
                          style: getRegularStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size11,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _statusBorderColor(
    DriverComplianceDocumentEntity doc,
    ColorScheme colorScheme,
  ) {
    if (doc.isRejected) return colorScheme.error.withValues(alpha: 0.5);
    if (doc.isReview) return Colors.amber.withValues(alpha: 0.5);
    if (doc.isExpiring) return Colors.orange.withValues(alpha: 0.5);
    if (doc.isValid) return Colors.green.withValues(alpha: 0.3);
    return Colors.transparent;
  }
}

class _DocumentStatusBadge extends StatelessWidget {
  const _DocumentStatusBadge({required this.document});

  final DriverComplianceDocumentEntity document;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final (label, color, bgColor) = _resolve(locale);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: getSemiBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size10,
          color: color,
        ),
      ),
    );
  }

  (String, Color, Color) _resolve(dynamic locale) {
    if (document.isRejected) {
      return (
        locale.driver_account_status_document_rejected,
        Colors.red.shade800,
        Colors.red.withValues(alpha: 0.12),
      );
    }
    if (document.isReview) {
      return (
        locale.driver_account_status_document_review,
        Colors.amber.shade900,
        Colors.amber.withValues(alpha: 0.12),
      );
    }
    if (document.isExpiring) {
      return (
        locale.driver_account_status_document_expiring,
        Colors.orange.shade900,
        Colors.orange.withValues(alpha: 0.12),
      );
    }
    return (
      locale.driver_account_status_document_valid,
      Colors.green.shade800,
      Colors.green.withValues(alpha: 0.12),
    );
  }
}
