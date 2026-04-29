import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_document_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/security_documents_list.dart';

class SecurityDocumentsFields extends StatelessWidget {
  const SecurityDocumentsFields({
    super.key,
    required this.documents,
    required this.onSelect,
    required this.onPreview,
  });

  final List<ProfileDocumentItemData> documents;
  final ValueChanged<ProfileDocumentType> onSelect;
  final ValueChanged<ProfileDocumentItemData> onPreview;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.profile_current_documents,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size13,
            color: context.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        SecurityDocumentsList(
          items: documents,
          onSelect: onSelect,
          onPreview: onPreview,
        ),
      ],
    );
  }
}
