import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/validators.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/driver_section_card.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/driver_upload_tile.dart';

class DriverProfileForm extends StatelessWidget {
  const DriverProfileForm({
    super.key,
    required this.formKey,
    required this.vehicleBrandController,
    required this.vehicleModelController,
    required this.plateNumberController,
    required this.vehicleType,
    required this.images,
    required this.isSubmitting,
    required this.onVehicleTypeChanged,
    required this.onPickImage,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController vehicleBrandController;
  final TextEditingController vehicleModelController;
  final TextEditingController plateNumberController;
  final String vehicleType;
  final Map<String, XFile?> images;
  final bool isSubmitting;
  final ValueChanged<String> onVehicleTypeChanged;
  final ValueChanged<String> onPickImage;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DriverSectionCard(
            title: locale.driver_profile_identity_section,
            child: _identityUploads(locale),
          ),
          const SizedBox(height: Spacing.sm),
          DriverSectionCard(
            title: locale.driver_profile_vehicle_section,
            child: _vehicleFields(context, locale),
          ),
          const SizedBox(height: Spacing.sm),
          DriverSectionCard(
            title: locale.driver_profile_vehicle_images_section,
            child: _vehicleUploads(locale),
          ),
          const SizedBox(height: Spacing.sm),
          AppButton.filled(
            text: locale.driver_profile_save,
            isLoading: isSubmitting,
            onPressed: isSubmitting ? null : onSubmit,
          ),
        ],
      ),
    );
  }

  Widget _identityUploads(dynamic locale) => Column(
    children: [
      _uploadTile(
        'portrait',
        locale.driver_profile_portrait_title,
        locale.driver_profile_portrait_subtitle,
        Icons.person_rounded,
      ),
      const SizedBox(height: 6),
      _uploadTile(
        'idFront',
        locale.driver_profile_id_front_title,
        locale.driver_profile_id_front_subtitle,
        Icons.badge_outlined,
      ),
      const SizedBox(height: 6),
      _uploadTile(
        'idBack',
        locale.driver_profile_id_back_title,
        locale.driver_profile_id_back_subtitle,
        Icons.credit_card,
      ),
      const SizedBox(height: 6),
      _uploadTile(
        'license',
        locale.driver_profile_license_title,
        locale.driver_profile_license_subtitle,
        Icons.assignment_ind_outlined,
      ),
    ],
  );

  Widget _vehicleFields(BuildContext context, dynamic locale) {
    final color = context.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          locale.driver_profile_vehicle_type,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size12,
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        DropdownButtonFormField<String>(
          value: vehicleType,
          decoration: InputDecoration(
            filled: true,
            fillColor: color.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: 16,
            ),
            border: _dropdownBorder(color.outline.withValues(alpha: 0.18)),
            enabledBorder: _dropdownBorder(
              color.outline.withValues(alpha: 0.18),
            ),
            focusedBorder: _dropdownBorder(color.primary),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: color.onSurface.withValues(alpha: 0.6),
          ),
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size12,
            color: color.onSurface,
          ),
          items: [
            DropdownMenuItem(
              value: 'car',
              child: Text(locale.driver_profile_vehicle_type_car),
            ),
            DropdownMenuItem(
              value: 'bike',
              child: Text(locale.driver_profile_vehicle_type_bike),
            ),
          ],
          onChanged: isSubmitting
              ? null
              : (value) {
                  if (value != null) onVehicleTypeChanged(value);
                },
        ),
        const SizedBox(height: Spacing.sm),
        _field(
          context,
          vehicleBrandController,
          locale.driver_profile_brand_label,
          locale.driver_profile_brand_hint,
          Icons.directions_car_outlined,
        ),
        const SizedBox(height: 8),
        _field(
          context,
          vehicleModelController,
          locale.driver_profile_model_label,
          locale.driver_profile_model_hint,
          Icons.tune_rounded,
        ),
        const SizedBox(height: 8),
        _field(
          context,
          plateNumberController,
          locale.driver_profile_plate_label,
          locale.driver_profile_plate_hint,
          Icons.pin_outlined,
          action: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _vehicleUploads(dynamic locale) => Column(
    children: [
      _uploadTile(
        'vehicle',
        locale.driver_profile_vehicle_photo_title,
        locale.driver_profile_vehicle_photo_subtitle,
        vehicleType == 'bike'
            ? Icons.two_wheeler_outlined
            : Icons.local_shipping_outlined,
      ),
      const SizedBox(height: 6),
      _uploadTile(
        'plate',
        locale.driver_profile_plate_photo_title,
        locale.driver_profile_plate_photo_subtitle,
        Icons.photo_camera_back_outlined,
      ),
    ],
  );

  Widget _uploadTile(
    String key,
    String title,
    String subtitle,
    IconData icon,
  ) => DriverUploadTile(
    title: title,
    subtitle: subtitle,
    icon: icon,
    image: images[key],
    onTap: () => onPickImage(key),
  );

  Widget _field(
    BuildContext context,
    TextEditingController controller,
    String label,
    String hint,
    IconData icon, {
    TextInputAction action = TextInputAction.next,
  }) {
    final color = context.colorScheme;
    return AuthTextField(
      controller: controller,
      label: label,
      hintText: hint,
      validator: (value) => Validations.validateRequired(context, value),
      textInputAction: action,
      enabled: !isSubmitting,
      prefixIcon: Icon(icon, color: color.onSurface.withValues(alpha: 0.6)),
    );
  }

  OutlineInputBorder _dropdownBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(Spacing.inputRadius),
    borderSide: BorderSide(color: color),
  );
}
