import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/presentation/extensions/profile_document_type_extension.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_document_item_data.dart';

class SecurityDocumentTile extends StatelessWidget {
  const SecurityDocumentTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  final ProfileDocumentItemData item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final colorScheme = context.colorScheme;
    final fileName = item.hasFile
        ? item.path.split(RegExp(r'[/\\]')).last
        : locale.profile_not_uploaded_yet;

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
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
                  item.type.titleOf(context),
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
                ),
              ],
            ),
          ),
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
    );
  }
}
