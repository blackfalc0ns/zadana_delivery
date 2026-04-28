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

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 320 ? 3 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: options.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: Spacing.sm,
            crossAxisSpacing: Spacing.sm,
            mainAxisExtent: 116,
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
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
        decoration: BoxDecoration(
          color: selected
              ? color.primary.withValues(alpha: 0.10)
              : color.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? color.primary
                : color.outlineVariant.withValues(alpha: 0.65),
            width: selected ? 1.6 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.shadow.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: selected
                        ? color.primary
                        : color.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: selected ? color.onPrimary : color.primary,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: selected ? color.primary : color.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? color.primary
                          : color.outlineVariant.withValues(alpha: 0.9),
                      width: selected ? 1.4 : 1.1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.shadow.withValues(alpha: 0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: selected
                      ? Icon(Icons.check, size: 13, color: color.onPrimary)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size13,
                    color: color.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
