import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_form_field.dart';

class PersonalInfoForm extends StatelessWidget {
  const PersonalInfoForm({
    super.key,
    required this.profilePhotoUrl,
    required this.isBusy,
    required this.onChangePhoto,
    required this.onDeletePhoto,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
  });

  final String profilePhotoUrl;
  final bool isBusy;
  final VoidCallback onChangePhoto;
  final VoidCallback onDeletePhoto;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final normalizedPhotoUrl = profilePhotoUrl.trim();
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              backgroundImage:
                  normalizedPhotoUrl.startsWith('http://') ||
                      normalizedPhotoUrl.startsWith('https://')
                  ? NetworkImage(normalizedPhotoUrl)
                  : null,
              child: normalizedPhotoUrl.isEmpty
                  ? const Icon(Icons.person_outline_rounded, size: 30)
                  : null,
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.driver_profile_portrait_title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton(
                        onPressed: isBusy ? null : onChangePhoto,
                        child: Text(
                          normalizedPhotoUrl.isEmpty
                              ? locale.driver_upload_status_upload
                              : locale.change_address,
                        ),
                      ),
                      if (normalizedPhotoUrl.isNotEmpty)
                        TextButton(
                          onPressed: isBusy ? null : onDeletePhoto,
                          child: Text(
                            Localizations.localeOf(context).languageCode == 'ar'
                                ? 'حذف الصورة'
                                : 'Remove photo',
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),
        ProfileFormField(
          controller: nameController,
          label: locale.label_full_name,
          hint: locale.hint_full_name,
          icon: Icons.badge_outlined,
        ),
        const SizedBox(height: Spacing.md),
        ProfileFormField(
          controller: emailController,
          label: locale.label_email,
          hint: locale.hint_email,
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: Spacing.md),
        ProfileFormField(
          controller: phoneController,
          label: locale.label_phone,
          hint: locale.hint_phone,
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: Spacing.md),
        ProfileFormField(
          controller: addressController,
          label: locale.driver_profile_address_label,
          hint: locale.driver_profile_address_hint,
          icon: Icons.home_work_outlined,
        ),
      ],
    );
  }
}
