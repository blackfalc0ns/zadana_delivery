import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_document_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_form_field.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/security_documents_list.dart';

class SecurityDocumentsFields extends StatelessWidget {
  const SecurityDocumentsFields({
    super.key,
    required this.nationalIdController,
    required this.licenseController,
    required this.documents,
    required this.onSelect,
  });

  final TextEditingController nationalIdController;
  final TextEditingController licenseController;
  final List<ProfileDocumentItemData> documents;
  final ValueChanged<ProfileDocumentType> onSelect;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileFormField(
          controller: nationalIdController,
          label: locale.driver_profile_national_id_label,
          hint: locale.driver_profile_national_id_hint,
          icon: Icons.badge_outlined,
        ),
        const SizedBox(height: Spacing.md),
        ProfileFormField(
          controller: licenseController,
          label: locale.driver_profile_license_number_label,
          hint: locale.driver_profile_license_number_hint,
          icon: Icons.assignment_outlined,
        ),
        const SizedBox(height: Spacing.base),
        Text(
          locale.profile_current_documents,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size13,
            color: context.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        SecurityDocumentsList(items: documents, onSelect: onSelect),
      ],
    );
  }
}
