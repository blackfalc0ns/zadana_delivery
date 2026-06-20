import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_support/order_support_attachment_preview.dart';

/// Section showing the attach button and selected image thumbnails.
class OrderSupportAttachmentsSection extends StatelessWidget {
  const OrderSupportAttachmentsSection({
    super.key,
    required this.selectedImages,
    required this.isSubmitting,
    required this.onPickImages,
    required this.onRemoveImage,
  });

  final List<XFile> selectedImages;
  final bool isSubmitting;
  final VoidCallback onPickImages;
  final ValueChanged<XFile> onRemoveImage;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: isSubmitting ? null : onPickImages,
            iconAlignment: IconAlignment.end,
            icon: const Icon(Icons.image_outlined, size: 22),
            label: Text(
              selectedImages.isEmpty
                  ? locale.order_support_attach_files
                  : locale.order_support_attach_more_files,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: scheme.primary,
              minimumSize: const Size.fromHeight(48),
              side: BorderSide(color: scheme.primary, width: 1.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        if (selectedImages.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: selectedImages
                .map(
                  (image) => OrderSupportAttachmentPreview(
                    imagePath: image.path,
                    onRemove: () => onRemoveImage(image),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ],
    );
  }
}
