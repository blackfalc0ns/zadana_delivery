import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/utils/driver_vehicle_type.dart';
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
    final options = [
      (
        value: DriverVehicleType.car,
        label: locale.driver_profile_vehicle_type_car,
      ),
      (
        value: DriverVehicleType.motorcycle,
        label: locale.driver_profile_vehicle_type_bike,
      ),
      (
        value: DriverVehicleType.scooter,
        label: locale.driver_profile_vehicle_type_scooter,
      ),
      (
        value: DriverVehicleType.van,
        label: locale.driver_profile_vehicle_type_van,
      ),
      (
        value: DriverVehicleType.bicycle,
        label: locale.driver_profile_vehicle_type_bicycle,
      ),
      (
        value: DriverVehicleType.truck,
        label: locale.driver_profile_vehicle_type_truck,
      ),
    ];

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
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - Spacing.sm) / 2;
            return Wrap(
              spacing: Spacing.sm,
              runSpacing: Spacing.sm,
              children: options.map((option) {
                return SizedBox(
                  width: itemWidth,
                  child: VehicleTypeChip(
                    label: option.label,
                    value: option.value,
                    groupValue: groupValue,
                    onChanged: onChanged,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
