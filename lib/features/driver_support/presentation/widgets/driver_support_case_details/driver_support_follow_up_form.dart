import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/features/driver_support/presentation/widgets/driver_support_case_details/driver_support_selected_attachment_chip.dart';

class DriverSupportFollowUpForm extends StatelessWidget {
  const DriverSupportFollowUpForm({
    super.key,
    required this.reasonCodes,
    required this.selectedReasonCode,
    required this.messageController,
    required this.selectedImages,
    required this.isSubmitting,
    required this.reasonLabelBuilder,
    required this.fileNameBuilder,
    required this.onReasonChanged,
    required this.onPickImages,
    required this.onRemoveImage,
    required this.onSubmit,
  });

  final List<String> reasonCodes;
  final String selectedReasonCode;
  final TextEditingController messageController;
  final List<XFile> selectedImages;
  final bool isSubmitting;
  final String Function(String code) reasonLabelBuilder;
  final String Function(XFile image) fileNameBuilder;
  final ValueChanged<String?> onReasonChanged;
  final VoidCallback onPickImages;
  final ValueChanged<XFile> onRemoveImage;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          initialValue: selectedReasonCode,
          borderRadius: BorderRadius.circular(18),
          decoration: InputDecoration(
            labelText: locale.driver_support_follow_up_reason,
            filled: true,
          ),
          items: reasonCodes
              .map(
                (reasonCode) => DropdownMenuItem<String>(
                  value: reasonCode,
                  child: Text(reasonLabelBuilder(reasonCode)),
                ),
              )
              .toList(growable: false),
          onChanged: isSubmitting ? null : onReasonChanged,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: messageController,
          maxLines: 4,
          textInputAction: TextInputAction.newline,
          decoration: InputDecoration(
            labelText: locale.driver_support_follow_up_message,
            alignLabelWithHint: true,
            hintText: locale.driver_support_follow_up_message_hint,
            filled: true,
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: isSubmitting ? null : onPickImages,
          icon: const Icon(Icons.image_outlined, size: 20),
          label: Text(
            selectedImages.isEmpty
                ? locale.driver_support_attach_files
                : locale.driver_support_attach_more_files,
          ),
        ),
        if (selectedImages.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selectedImages
                .map(
                  (image) => DriverSupportSelectedAttachmentChip(
                    fileName: fileNameBuilder(image),
                    onRemove: () => onRemoveImage(image),
                  ),
                )
                .toList(growable: false),
          ),
        ],
        const SizedBox(height: 12),
        AppButton.filled(
          text: locale.driver_support_send_follow_up,
          isLoading: isSubmitting,
          onPressed: onSubmit,
        ),
      ],
    );
  }
}
