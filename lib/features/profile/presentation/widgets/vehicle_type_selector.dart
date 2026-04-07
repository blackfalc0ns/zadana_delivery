import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/vehicle_type_chip.dart';

class VehicleTypeSelector extends StatelessWidget {
  const VehicleTypeSelector({
    super.key,
    required this.groupValue,
    required this.onChanged,
  });

  final String groupValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.driver_profile_vehicle_type_label,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size11,
            color: context.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.sm),
        Row(
          children: [
            Expanded(
              child: VehicleTypeChip(
                label: locale.driver_profile_vehicle_type_car,
                value: 'car',
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: VehicleTypeChip(
                label: locale.driver_profile_vehicle_type_bike,
                value: 'bike',
                groupValue: groupValue,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
