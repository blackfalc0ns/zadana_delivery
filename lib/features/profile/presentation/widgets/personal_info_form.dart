import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_form_field.dart';

class PersonalInfoForm extends StatelessWidget {
  const PersonalInfoForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return Column(
      children: [
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
