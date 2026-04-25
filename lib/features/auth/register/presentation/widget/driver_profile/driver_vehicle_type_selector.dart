import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/utils/driver_vehicle_type.dart';

class DriverVehicleTypeSelector extends StatelessWidget {
  const DriverVehicleTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  final String selectedType;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = _options(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: options.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: Spacing.sm,
        crossAxisSpacing: Spacing.sm,
        childAspectRatio: 1.18,
      ),
      itemBuilder: (context, index) {
        final option = options[index];
        return _VehicleOptionCard(
          title: option.title,
          subtitle: option.subtitle,
          icon: option.icon,
          selected: selectedType == option.value,
          onTap: () => onChanged(option.value),
        );
      },
    );
  }

  List<_VehicleTypeOption> _options(BuildContext context) {
    final locale = context.localization;
    return [
      _VehicleTypeOption(
        value: DriverVehicleType.car,
        title: locale.driver_profile_vehicle_type_car,
        subtitle: locale.driver_vehicle_type_car_subtitle,
        icon: Icons.directions_car_filled_outlined,
      ),
      _VehicleTypeOption(
        value: DriverVehicleType.motorcycle,
        title: locale.driver_profile_vehicle_type_bike,
        subtitle: locale.driver_vehicle_type_motorcycle_subtitle,
        icon: Icons.two_wheeler_outlined,
      ),
      _VehicleTypeOption(
        value: DriverVehicleType.scooter,
        title: locale.driver_profile_vehicle_type_scooter,
        subtitle: locale.driver_vehicle_type_scooter_subtitle,
        icon: Icons.electric_scooter_outlined,
      ),
      _VehicleTypeOption(
        value: DriverVehicleType.van,
        title: locale.driver_profile_vehicle_type_van,
        subtitle: locale.driver_vehicle_type_van_subtitle,
        icon: Icons.airport_shuttle_outlined,
      ),
      _VehicleTypeOption(
        value: DriverVehicleType.bicycle,
        title: locale.driver_profile_vehicle_type_bicycle,
        subtitle: locale.driver_vehicle_type_bicycle_subtitle,
        icon: Icons.pedal_bike_outlined,
      ),
      _VehicleTypeOption(
        value: DriverVehicleType.truck,
        title: locale.driver_profile_vehicle_type_truck,
        subtitle: locale.driver_vehicle_type_truck_subtitle,
        icon: Icons.local_shipping_outlined,
      ),
    ];
  }
}

class _VehicleTypeOption {
  const _VehicleTypeOption({
    required this.value,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String value;
  final String title;
  final String subtitle;
  final IconData icon;
}

class _VehicleOptionCard extends StatelessWidget {
  const _VehicleOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? color.primary.withValues(alpha: 0.10)
              : color.surfaceContainerLow,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected
                ? color.primary
                : color.outlineVariant.withValues(alpha: 0.65),
            width: selected ? 1.6 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.shadow.withValues(alpha: 0.10),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: selected
                        ? color.primary
                        : color.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: selected ? color.onPrimary : color.primary,
                  ),
                ),
                const Spacer(),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: selected ? color.primary : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? color.primary
                          : color.outlineVariant.withValues(alpha: 0.9),
                    ),
                  ),
                  child: selected
                      ? Icon(Icons.check, size: 14, color: color.onPrimary)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: color.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
