import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

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
    final locale = context.localization;

    return Row(
      children: [
        Expanded(
          child: _VehicleOptionCard(
            title: locale.driver_profile_vehicle_type_car,
            subtitle: locale.driver_vehicle_type_car_subtitle,
            icon: Icons.local_shipping_outlined,
            selected: selectedType == 'car',
            onTap: () => onChanged('car'),
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: _VehicleOptionCard(
            title: locale.driver_profile_vehicle_type_bike,
            subtitle: locale.driver_vehicle_type_bike_subtitle,
            icon: Icons.two_wheeler_outlined,
            selected: selectedType == 'bike',
            onTap: () => onChanged('bike'),
          ),
        ),
      ],
    );
  }
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
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size11,
                color: color.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
