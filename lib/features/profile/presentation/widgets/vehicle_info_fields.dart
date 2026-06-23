import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/validators.dart';
import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/driver_region_entity.dart';
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
    required this.nationalIdExpiryController,
    required this.driverLicenseExpiryController,
    required this.vehicleLicenseNumberController,
    required this.vehicleLicenseExpiryController,
    required this.regionCities,
    required this.isRegionCitiesLoading,
    required this.isCitiesLoading,
    required this.regions,
    required this.selectedCityId,
    required this.selectedRegionCode,
    required this.selectedCityName,
    required this.selectedRegionName,
    required this.regionCitiesFailure,
    required this.citiesFailure,
    required this.onRetryRegionCities,
    required this.onRegionSelected,
    required this.onCitySelected,
    required this.onPickDate,
  });

  final String groupValue;
  final ValueChanged<String> onTypeChanged;
  final TextEditingController nationalIdController;
  final TextEditingController licenseController;
  final TextEditingController nationalIdExpiryController;
  final TextEditingController driverLicenseExpiryController;
  final TextEditingController vehicleLicenseNumberController;
  final TextEditingController vehicleLicenseExpiryController;
  final List<DriverRegionCityEntity> regionCities;
  final bool isRegionCitiesLoading;
  final bool isCitiesLoading;
  final List<DriverRegionEntity> regions;
  final String selectedCityId;
  final String selectedRegionCode;
  final String selectedCityName;
  final String selectedRegionName;
  final Failure? regionCitiesFailure;
  final Failure? citiesFailure;
  final VoidCallback onRetryRegionCities;
  final void Function(String regionCode, String regionName) onRegionSelected;
  final ValueChanged<DriverRegionCityEntity> onCitySelected;
  final ValueChanged<TextEditingController> onPickDate;

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
                isCitiesLoading: isCitiesLoading,
                regions: regions,
                selectedCityId: selectedCityId,
                selectedRegionCode: selectedRegionCode,
                selectedCityName: selectedCityName,
                selectedRegionName: selectedRegionName,
                failure: regionCitiesFailure,
                citiesFailure: citiesFailure,
                onRetry: onRetryRegionCities,
                onRegionSelected: onRegionSelected,
                onCitySelected: onCitySelected,
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
                controller: nationalIdExpiryController,
                label: locale.driver_profile_national_id_expiry_label,
                hint: locale.driver_profile_expiry_date_hint,
                icon: Icons.event_outlined,
                readOnly: true,
                onTap: () => onPickDate(nationalIdExpiryController),
                suffixIcon: const Icon(Icons.calendar_month_outlined),
                validator: (value) =>
                    Validations.validateFutureDate(context, value),
              ),
              const SizedBox(height: Spacing.md),
              ProfileFormField(
                controller: licenseController,
                label: locale.driver_profile_license_number_label,
                hint: locale.driver_profile_license_number_hint,
                icon: Icons.assignment_outlined,
              ),
              const SizedBox(height: Spacing.md),
              ProfileFormField(
                controller: driverLicenseExpiryController,
                label: locale.driver_profile_driver_license_expiry_label,
                hint: locale.driver_profile_expiry_date_hint,
                icon: Icons.event_outlined,
                readOnly: true,
                onTap: () => onPickDate(driverLicenseExpiryController),
                suffixIcon: const Icon(Icons.calendar_month_outlined),
                validator: (value) =>
                    Validations.validateFutureDate(context, value),
              ),
              const SizedBox(height: Spacing.md),
              ProfileFormField(
                controller: vehicleLicenseNumberController,
                label: locale.driver_profile_vehicle_license_number_label,
                hint: locale.driver_profile_vehicle_license_number_hint,
                icon: Icons.description_outlined,
              ),
              const SizedBox(height: Spacing.md),
              ProfileFormField(
                controller: vehicleLicenseExpiryController,
                label: locale.driver_profile_vehicle_license_expiry_label,
                hint: locale.driver_profile_expiry_date_hint,
                icon: Icons.event_outlined,
                readOnly: true,
                onTap: () => onPickDate(vehicleLicenseExpiryController),
                suffixIcon: const Icon(Icons.calendar_month_outlined),
                validator: (value) =>
                    Validations.validateFutureDate(context, value),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
