import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/driver_zone_entity.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_profile/driver_zone_selector.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_form_field.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/vehicle_type_selector.dart';

class VehicleInfoFields extends StatelessWidget {
  const VehicleInfoFields({
    super.key,
    required this.groupValue,
    required this.onTypeChanged,
    required this.nationalIdController,
    required this.licenseController,
    required this.zones,
    required this.isZonesLoading,
    required this.selectedZoneId,
    required this.selectedZoneName,
    required this.zonesFailure,
    required this.onRetryZones,
    required this.onZoneChanged,
  });

  final String groupValue;
  final ValueChanged<String> onTypeChanged;
  final TextEditingController nationalIdController;
  final TextEditingController licenseController;
  final List<DriverZoneEntity> zones;
  final bool isZonesLoading;
  final String selectedZoneId;
  final String selectedZoneName;
  final Failure? zonesFailure;
  final VoidCallback onRetryZones;
  final ValueChanged<DriverZoneEntity> onZoneChanged;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return Column(
      children: [
        VehicleTypeSelector(groupValue: groupValue, onChanged: onTypeChanged),
        const SizedBox(height: Spacing.md),
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
        const SizedBox(height: Spacing.md),
        DriverZoneSelector(
          zones: zones,
          isLoading: isZonesLoading,
          selectedZoneId: selectedZoneId,
          selectedZoneName: selectedZoneName,
          selectedZoneCity: '',
          failure: zonesFailure,
          onRetry: onRetryZones,
          onChanged: onZoneChanged,
        ),
      ],
    );
  }
}
