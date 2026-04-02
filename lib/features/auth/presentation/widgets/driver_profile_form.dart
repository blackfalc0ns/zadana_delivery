import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
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
    required this.addressController,
    required this.nationalIdController,
    required this.licenseNumberController,
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
  final TextEditingController addressController;
  final TextEditingController nationalIdController;
  final TextEditingController licenseNumberController;
  final TextEditingController vehicleBrandController;
  final TextEditingController vehicleModelController;
  final TextEditingController plateNumberController;
  final String vehicleType;
  final Map<String, String> images;
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
          _ProgressHighlights(images: images, vehicleType: vehicleType),
          const SizedBox(height: Spacing.base),
          DriverSectionCard(
            title: _copy(
              context,
              'الهوية والمعلومات الرسمية',
              'Identity and official details',
            ),
            subtitle: _copy(
              context,
              'أدخل العنوان والبيانات الرسمية الأساسية الخاصة بالمندوب.',
              'Enter the driver address and official identity details.',
            ),
            child: Column(
              children: [
                _field(
                  context,
                  controller: addressController,
                  label: _copy(context, 'العنوان', 'Address'),
                  hint: _copy(
                    context,
                    'مثال: مدينة نصر، شارع عباس العقاد',
                    'Example: Nasr City, Abbas El Akkad Street',
                  ),
                  icon: Icons.home_work_outlined,
                ),
                const SizedBox(height: 10),
                _field(
                  context,
                  controller: nationalIdController,
                  label: _copy(context, 'الرقم القومي', 'National ID'),
                  hint: _copy(
                    context,
                    'أدخل الرقم القومي',
                    'Enter national ID',
                  ),
                  icon: Icons.badge_outlined,
                ),
                const SizedBox(height: 10),
                _field(
                  context,
                  controller: licenseNumberController,
                  label: _copy(context, 'رقم الرخصة', 'License number'),
                  hint: _copy(
                    context,
                    'أدخل رقم الرخصة',
                    'Enter license number',
                  ),
                  icon: Icons.assignment_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.base),
          DriverSectionCard(
            title: locale.driver_profile_vehicle_section,
            subtitle: _copy(
              context,
              'حدد نوع المركبة وأدخل العلامة التجارية والموديل ورقم اللوحة.',
              'Choose the vehicle type and enter the brand, model, and plate number.',
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  locale.driver_profile_vehicle_type,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size12,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _VehicleChoiceChip(
                        title: locale.driver_profile_vehicle_type_car,
                        icon: Icons.local_shipping_outlined,
                        selected: vehicleType == 'car',
                        onTap: isSubmitting
                            ? null
                            : () => onVehicleTypeChanged('car'),
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: _VehicleChoiceChip(
                        title: locale.driver_profile_vehicle_type_bike,
                        icon: Icons.two_wheeler_outlined,
                        selected: vehicleType == 'bike',
                        onTap: isSubmitting
                            ? null
                            : () => onVehicleTypeChanged('bike'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _field(
                  context,
                  controller: vehicleBrandController,
                  label: locale.driver_profile_brand_label,
                  hint: locale.driver_profile_brand_hint,
                  icon: Icons.directions_car_outlined,
                ),
                const SizedBox(height: 10),
                _field(
                  context,
                  controller: vehicleModelController,
                  label: locale.driver_profile_model_label,
                  hint: locale.driver_profile_model_hint,
                  icon: Icons.tune_rounded,
                ),
                const SizedBox(height: 10),
                _field(
                  context,
                  controller: plateNumberController,
                  label: locale.driver_profile_plate_label,
                  hint: locale.driver_profile_plate_hint,
                  icon: Icons.pin_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.base),
          DriverSectionCard(
            title: _copy(
              context,
              'رفع الصور المطلوبة',
              'Upload required images',
            ),
            subtitle: _copy(
              context,
              'ارفع الصور الأساسية بوضوح لتسريع مراجعة حسابك.',
              'Upload the essential images clearly to speed up your account review.',
            ),
            child: Column(
              children: [
                _uploadTile(
                  context,
                  'portrait',
                  locale.driver_profile_portrait_title,
                  locale.driver_profile_portrait_subtitle,
                  Icons.person_rounded,
                ),
                const SizedBox(height: 8),
                _uploadTile(
                  context,
                  'idFront',
                  locale.driver_profile_id_front_title,
                  locale.driver_profile_id_front_subtitle,
                  Icons.badge_outlined,
                ),
                const SizedBox(height: 8),
                _uploadTile(
                  context,
                  'license',
                  locale.driver_profile_license_title,
                  locale.driver_profile_license_subtitle,
                  Icons.assignment_ind_outlined,
                ),
                const SizedBox(height: 8),
                _uploadTile(
                  context,
                  'vehicle',
                  locale.driver_profile_vehicle_photo_title,
                  locale.driver_profile_vehicle_photo_subtitle,
                  vehicleType == 'bike'
                      ? Icons.two_wheeler_outlined
                      : Icons.local_shipping_outlined,
                ),
                const SizedBox(height: 8),
                _uploadTile(
                  context,
                  'plate',
                  locale.driver_profile_plate_photo_title,
                  locale.driver_profile_plate_photo_subtitle,
                  Icons.photo_camera_back_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.lg),
          AppButton.filled(
            text: locale.driver_profile_save,
            isLoading: isSubmitting,
            onPressed: isSubmitting ? null : onSubmit,
            height: 54,
            borderRadius: 20,
          ),
        ],
      ),
    );
  }

  String _copy(BuildContext context, String ar, String en) {
    return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
  }

  Widget _uploadTile(
    BuildContext context,
    String key,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return DriverUploadTile(
      title: title,
      subtitle: subtitle,
      icon: icon,
      imagePath: images[key],
      onTap: () => onPickImage(key),
    );
  }

  Widget _field(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
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
}

class _ProgressHighlights extends StatelessWidget {
  const _ProgressHighlights({required this.images, required this.vehicleType});

  final Map<String, String> images;
  final String vehicleType;

  @override
  Widget build(BuildContext context) {
    final uploadedCount = images.values
        .where((value) => value.trim().isNotEmpty)
        .length;
    final items = [
      (
        Localizations.localeOf(context).languageCode == 'ar'
            ? 'الصور المرفوعة'
            : 'Uploaded images',
        '$uploadedCount/5',
        Icons.image_outlined,
      ),
      (
        Localizations.localeOf(context).languageCode == 'ar'
            ? 'نوع المركبة'
            : 'Vehicle type',
        vehicleType == 'bike'
            ? (Localizations.localeOf(context).languageCode == 'ar'
                  ? 'دراجة'
                  : 'Bike')
            : (Localizations.localeOf(context).languageCode == 'ar'
                  ? 'سيارة'
                  : 'Car'),
        Icons.speed_rounded,
      ),
    ];

    return Row(
      children: items
          .map(
            (item) => Expanded(
              child: Container(
                margin: EdgeInsetsDirectional.only(
                  end: item == items.first ? Spacing.sm : 0,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.08),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(item.$3, color: AppColors.primary, size: 20),
                    const SizedBox(height: 10),
                    Text(
                      item.$1,
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.$2,
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _VehicleChoiceChip extends StatelessWidget {
  const _VehicleChoiceChip({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.10)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.border.withValues(alpha: 0.9),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: Text(
                title,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size12,
                  color: selected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
