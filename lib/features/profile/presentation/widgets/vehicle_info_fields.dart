import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_form_field.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/vehicle_type_selector.dart';

class VehicleInfoFields extends StatelessWidget {
  const VehicleInfoFields({
    super.key,
    required this.groupValue,
    required this.onTypeChanged,
    required this.brandController,
    required this.modelController,
    required this.plateController,
  });

  final String groupValue;
  final ValueChanged<String> onTypeChanged;
  final TextEditingController brandController;
  final TextEditingController modelController;
  final TextEditingController plateController;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return Column(
      children: [
        VehicleTypeSelector(groupValue: groupValue, onChanged: onTypeChanged),
        const SizedBox(height: Spacing.md),
        ProfileFormField(
          controller: brandController,
          label: locale.driver_profile_brand_label,
          hint: locale.driver_profile_brand_hint,
          icon: Icons.directions_car_outlined,
        ),
        const SizedBox(height: Spacing.md),
        ProfileFormField(
          controller: modelController,
          label: locale.driver_profile_model_label,
          hint: locale.driver_profile_model_hint,
          icon: Icons.tune_rounded,
        ),
        const SizedBox(height: Spacing.md),
        ProfileFormField(
          controller: plateController,
          label: locale.driver_profile_plate_label,
          hint: locale.driver_profile_plate_hint,
          icon: Icons.pin_outlined,
        ),
      ],
    );
  }
}
