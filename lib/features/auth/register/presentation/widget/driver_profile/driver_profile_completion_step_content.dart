import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/validators.dart';
import 'package:zadana_delivery/core/utils/driver_vehicle_type.dart';
import 'package:zadana_delivery/core/widgets/auth/auth_text_field.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/driver_zone_entity.dart';
import 'package:zadana_delivery/features/auth/register/presentation/manager/driver_profile_completion_state.dart';
import 'package:zadana_delivery/features/auth/register/presentation/manager/register_zones_cubit.dart';
import 'package:zadana_delivery/features/auth/register/presentation/manager/register_zones_state.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_profile/driver_profile_review_list.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_profile/driver_region_city_selector.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_profile/driver_vehicle_type_selector.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_section_card.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_upload_tile.dart';

class DriverProfileCompletionStepContent extends StatelessWidget {
  const DriverProfileCompletionStepContent({
    super.key,
    required this.state,
    required this.addressController,
    required this.nationalIdController,
    required this.licenseNumberController,
    required this.onVehicleTypeChanged,
    required this.onRegionCityChanged,
    required this.onPickImage,
  });

  final DriverProfileCompletionState state;
  final TextEditingController addressController;
  final TextEditingController nationalIdController;
  final TextEditingController licenseNumberController;
  final ValueChanged<String> onVehicleTypeChanged;
  final ValueChanged<DriverRegionCityEntity> onRegionCityChanged;
  final ValueChanged<String> onPickImage;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;
    final isSubmitting = state.isLoading;
    final hasSelectedVehicle = state.draft.vehicleType.trim().isNotEmpty;
    final normalizedVehicleType = hasSelectedVehicle
        ? DriverVehicleType.normalize(state.draft.vehicleType)
        : '';

    switch (state.currentStep) {
      case 0:
        return DriverSectionCard(
          title: locale.driver_profile_identity_card_title,
          subtitle: locale.driver_profile_identity_card_subtitle,
          child: Column(
            children: [
              _buildField(
                context,
                controller: addressController,
                label: locale.driver_profile_address_label,
                hint: locale.driver_profile_address_hint,
                icon: Icons.home_work_outlined,
                isSubmitting: isSubmitting,
              ),
              const SizedBox(height: 12),
              _buildField(
                context,
                controller: nationalIdController,
                label: locale.driver_profile_national_id_label,
                hint: locale.driver_profile_national_id_hint,
                icon: Icons.badge_outlined,
                isSubmitting: isSubmitting,
              ),
              const SizedBox(height: 12),
              _buildField(
                context,
                controller: licenseNumberController,
                label: locale.driver_profile_license_number_label,
                hint: locale.driver_profile_license_number_hint,
                icon: Icons.assignment_outlined,
                isSubmitting: isSubmitting,
              ),
            ],
          ),
        );
      case 1:
        return BlocBuilder<RegisterRegionsCubit, RegisterRegionsState>(
          builder: (context, regionCitiesState) {
            return DriverSectionCard(
              title: locale.driver_profile_vehicle_card_title,
              subtitle: locale.driver_profile_vehicle_card_subtitle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DriverVehicleTypeSelector(
                    selectedType: state.draft.vehicleType,
                    onChanged: isSubmitting ? (_) {} : onVehicleTypeChanged,
                  ),
                  const SizedBox(height: 14),
                  DriverRegionCitySelector(
                    regionCities: regionCitiesState.regionCities,
                    isLoading: regionCitiesState.isLoading,
                    selectedCityId: state.draft.cityId,
                    selectedRegionCode: state.draft.regionCode,
                    selectedCityName: state.draft.cityName,
                    selectedRegionName: state.draft.regionName,
                    failure: regionCitiesState.failure,
                    onRetry: context
                        .read<RegisterRegionsCubit>()
                        .loadRegionCities,
                    onChanged: isSubmitting ? (_) {} : onRegionCityChanged,
                  ),
                  if (hasSelectedVehicle) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: color.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _vehicleTypeIcon(normalizedVehicleType),
                            color: color.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              locale.driver_profile_vehicle_selected_message(
                                _vehicleTypeLabel(
                                  context,
                                  normalizedVehicleType,
                                ),
                              ),
                              style: getRegularStyle(
                                fontFamily: FontConstant.cairo,
                                color: color.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      case 2:
        return DriverSectionCard(
          title: locale.driver_profile_uploads_card_title,
          subtitle: locale.driver_profile_uploads_card_subtitle,
          child: Column(
            children: [
              _buildUploadTile(
                keyName: 'portrait',
                title: locale.driver_profile_portrait_title,
                subtitle: locale.driver_profile_portrait_subtitle,
                icon: Icons.person_rounded,
                imagePath: state.draft.images['portrait'],
              ),
              const SizedBox(height: 8),
              _buildUploadTile(
                keyName: 'idFront',
                title: locale.driver_profile_id_front_title,
                subtitle: locale.driver_profile_id_front_subtitle,
                icon: Icons.badge_outlined,
                imagePath: state.draft.images['idFront'],
              ),
              const SizedBox(height: 8),
              _buildUploadTile(
                keyName: 'idBack',
                title: locale.driver_profile_id_back_title,
                subtitle: locale.driver_profile_id_back_subtitle,
                icon: Icons.badge_outlined,
                imagePath: state.draft.images['idBack'],
              ),
              const SizedBox(height: 8),
              _buildUploadTile(
                keyName: 'license',
                title: locale.driver_profile_license_title,
                subtitle: locale.driver_profile_license_subtitle,
                icon: Icons.assignment_ind_outlined,
                imagePath: state.draft.images['license'],
              ),
              const SizedBox(height: 8),
              _buildUploadTile(
                keyName: 'vehicle',
                title: locale.driver_profile_vehicle_photo_title,
                subtitle: locale.driver_profile_vehicle_photo_subtitle,
                icon: _vehicleTypeIcon(normalizedVehicleType),
                imagePath: state.draft.images['vehicle'],
              ),
            ],
          ),
        );
      default:
        return DriverSectionCard(
          title: locale.driver_profile_review_card_title,
          subtitle: locale.driver_profile_review_card_subtitle,
          child: DriverProfileReviewList(
            items: [
              (
                label: locale.driver_profile_address_label,
                value: addressController.text,
              ),
              (
                label: locale.driver_profile_national_id_label,
                value: nationalIdController.text,
              ),
              (
                label: locale.driver_profile_license_number_label,
                value: licenseNumberController.text,
              ),
              (
                label: locale.driver_profile_vehicle_type_label,
                value: hasSelectedVehicle
                    ? _vehicleTypeLabel(context, normalizedVehicleType)
                    : locale.driver_profile_incomplete,
              ),
              (
                label: locale.driver_profile_zone_label,
                value: state.draft.cityName.isEmpty
                    ? locale.driver_profile_incomplete
                    : (state.draft.regionName.isEmpty
                          ? state.draft.cityName
                          : '${state.draft.cityName}, ${state.draft.regionName}'),
              ),
              (
                label: locale.driver_profile_portrait_title,
                value: state.draft.images['portrait'] ?? '',
              ),
              (
                label: locale.driver_profile_id_front_title,
                value: state.draft.images['idFront'] ?? '',
              ),
              (
                label: locale.driver_profile_id_back_title,
                value: state.draft.images['idBack'] ?? '',
              ),
              (
                label: locale.driver_profile_license_title,
                value: state.draft.images['license'] ?? '',
              ),
              (
                label: locale.driver_profile_vehicle_photo_title,
                value: state.draft.images['vehicle'] ?? '',
              ),
            ],
          ),
        );
    }
  }

  Widget _buildField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isSubmitting,
  }) {
    final color = context.colorScheme;

    return AuthTextField(
      controller: controller,
      label: label,
      hintText: hint,
      validator: (value) => Validations.validateRequired(context, value),
      enabled: !isSubmitting,
      prefixIcon: Icon(icon, color: color.onSurface.withValues(alpha: 0.6)),
    );
  }

  Widget _buildUploadTile({
    required String keyName,
    required String title,
    required String subtitle,
    required IconData icon,
    required String? imagePath,
  }) {
    return DriverUploadTile(
      title: title,
      subtitle: subtitle,
      icon: icon,
      imagePath: imagePath,
      onTap: () => onPickImage(keyName),
    );
  }

  String _vehicleTypeLabel(BuildContext context, String vehicleType) {
    final locale = context.localization;
    return switch (DriverVehicleType.normalize(vehicleType)) {
      DriverVehicleType.car => locale.driver_profile_vehicle_type_car,
      DriverVehicleType.motorcycle => locale.driver_profile_vehicle_type_bike,
      DriverVehicleType.scooter => locale.driver_profile_vehicle_type_scooter,
      DriverVehicleType.van => locale.driver_profile_vehicle_type_van,
      DriverVehicleType.bicycle => locale.driver_profile_vehicle_type_bicycle,
      DriverVehicleType.truck => locale.driver_profile_vehicle_type_truck,
      _ => locale.driver_profile_vehicle_type_car,
    };
  }

  IconData _vehicleTypeIcon(String vehicleType) {
    return switch (DriverVehicleType.normalize(vehicleType)) {
      DriverVehicleType.car => Icons.directions_car_filled_outlined,
      DriverVehicleType.motorcycle => Icons.two_wheeler_outlined,
      DriverVehicleType.scooter => Icons.electric_scooter_outlined,
      DriverVehicleType.van => Icons.airport_shuttle_outlined,
      DriverVehicleType.bicycle => Icons.pedal_bike_outlined,
      DriverVehicleType.truck => Icons.local_shipping_outlined,
      _ => Icons.inventory_2_outlined,
    };
  }
}
