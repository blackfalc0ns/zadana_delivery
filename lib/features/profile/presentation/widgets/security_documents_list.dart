import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_document_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/security_document_tile.dart';

class SecurityDocumentsList extends StatelessWidget {
  const SecurityDocumentsList({
    super.key,
    required this.items,
    required this.onSelect,
    required this.onPreview,
  });

  final List<ProfileDocumentItemData> items;
  final ValueChanged<ProfileDocumentType> onSelect;
  final ValueChanged<ProfileDocumentItemData> onPreview;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          SecurityDocumentTile(
            item: items[index],
            onTap: () => onSelect(items[index].type),
            onPreview: () => onPreview(items[index]),
          ),
          if (index < items.length - 1) const SizedBox(height: Spacing.sm),
        ],
      ],
    );
  }
}
