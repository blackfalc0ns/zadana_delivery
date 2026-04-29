import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/driver_zone_entity.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_profile/driver_region_city_selector.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_profile/driver_vehicle_type_selector.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_section_card.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_form_field.dart';

class VehicleInfoFields extends StatelessWidget {
  const VehicleInfoFields({
    super.key,
    required this.groupValue,
    required this.onTypeChanged,
    required this.nationalIdController,
    required this.licenseController,
    required this.regionCities,
    required this.isRegionCitiesLoading,
    required this.selectedCityId,
    required this.selectedRegionCode,
    required this.selectedCityName,
    required this.selectedRegionName,
    required this.regionCitiesFailure,
    required this.onRetryRegionCities,
    required this.onRegionCityChanged,
  });

  final String groupValue;
  final ValueChanged<String> onTypeChanged;
  final TextEditingController nationalIdController;
  final TextEditingController licenseController;
  final List<DriverRegionCityEntity> regionCities;
  final bool isRegionCitiesLoading;
  final String selectedCityId;
  final String selectedRegionCode;
  final String selectedCityName;
  final String selectedRegionName;
  final Failure? regionCitiesFailure;
  final VoidCallback onRetryRegionCities;
  final ValueChanged<DriverRegionCityEntity> onRegionCityChanged;

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
              DriverRegionCitySelector(
                regionCities: regionCities,
                isLoading: isRegionCitiesLoading,
                selectedCityId: selectedCityId,
                selectedRegionCode: selectedRegionCode,
                selectedCityName: selectedCityName,
                selectedRegionName: selectedRegionName,
                failure: regionCitiesFailure,
                onRetry: onRetryRegionCities,
                onChanged: onRegionCityChanged,
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
