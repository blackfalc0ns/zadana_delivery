import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/driver_zone_entity.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_profile/driver_vehicle_type_selector.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_profile/driver_zone_selector.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_section_card.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_form_field.dart';

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
    required this.selectedRegionCode,
    required this.selectedZoneName,
    required this.selectedZoneCity,
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
  final String selectedRegionCode;
  final String selectedZoneName;
  final String selectedZoneCity;
  final Failure? zonesFailure;
  final VoidCallback onRetryZones;
  final ValueChanged<DriverZoneEntity> onZoneChanged;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DriverSectionCard(
          title: locale.driver_profile_vehicle_card_title,
          subtitle: locale.driver_profile_vehicle_card_subtitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DriverVehicleTypeSelector(
                selectedType: groupValue,
                onChanged: onTypeChanged,
              ),
              const SizedBox(height: Spacing.md),
              DriverZoneSelector(
                zones: zones,
                isLoading: isZonesLoading,
                selectedZoneId: selectedZoneId,
                selectedRegionCode: selectedRegionCode,
                selectedZoneName: selectedZoneName,
                selectedZoneCity: selectedZoneCity,
                failure: zonesFailure,
                onRetry: onRetryZones,
                onChanged: onZoneChanged,
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.md),
        DriverSectionCard(
          title: locale.driver_profile_identity_card_title,
          subtitle: locale.driver_profile_identity_card_subtitle,
          child: Column(
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
            ],
          ),
        ),
      ],
    );
  }
}
