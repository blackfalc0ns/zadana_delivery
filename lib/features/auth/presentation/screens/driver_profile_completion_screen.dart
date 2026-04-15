import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/validators.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/custom_snackbar.dart';
import 'package:zadana_delivery/features/auth/data/driver_profile_service.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/driver_profile/driver_profile_review_list.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/driver_profile/driver_profile_step_header.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/driver_profile/driver_profile_steps_bar.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/driver_profile/driver_vehicle_type_selector.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/driver_section_card.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/driver_upload_tile.dart';

class DriverProfileCompletionScreen extends StatefulWidget {
  const DriverProfileCompletionScreen({super.key});

  @override
  State<DriverProfileCompletionScreen> createState() =>
      _DriverProfileCompletionScreenState();
}

class _DriverProfileCompletionScreenState
    extends State<DriverProfileCompletionScreen> {
  final _service = DriverProfileService();
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _vehicleBrandController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _plateNumberController = TextEditingController();
  final _imagePicker = ImagePicker();
  final _images = <String, String>{
    'portrait': '',
    'idFront': '',
    'license': '',
    'vehicle': '',
    'plate': '',
  };

  int _currentStep = 0;
  bool _isSubmitting = false;
  bool _didLoadInitialData = false;
  String _vehicleType = 'car';

  List<String> _stepTitles(BuildContext context) => [
    context.localization.driver_profile_step_identity_title,
    context.localization.driver_profile_step_vehicle_title,
    context.localization.driver_profile_step_uploads_title,
    context.localization.driver_profile_step_submit_title,
  ];

  List<String> _stepSubtitles(BuildContext context) => [
    context.localization.driver_profile_step_identity_subtitle,
    context.localization.driver_profile_step_vehicle_subtitle,
    context.localization.driver_profile_step_uploads_subtitle,
    context.localization.driver_profile_step_submit_subtitle,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didLoadInitialData) return;
    _didLoadInitialData = true;
    _loadInitialData();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _nationalIdController.dispose();
    _licenseNumberController.dispose();
    _vehicleBrandController.dispose();
    _vehicleModelController.dispose();
    _plateNumberController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    final draft = _service.profileDraft;
    final seededDraft = _withFallbackDraft(draft);

    _vehicleType = seededDraft.vehicleType;
    _addressController.text = seededDraft.address;
    _nationalIdController.text = seededDraft.nationalId;
    _licenseNumberController.text = seededDraft.licenseNumber;
    _vehicleBrandController.text = seededDraft.vehicleBrand;
    _vehicleModelController.text = seededDraft.vehicleModel;
    _plateNumberController.text = seededDraft.plateNumber;
    _images
      ..clear()
      ..addAll({
        'portrait': seededDraft.images['portrait'] ?? '',
        'idFront': seededDraft.images['idFront'] ?? '',
        'license': seededDraft.images['license'] ?? '',
        'vehicle': seededDraft.images['vehicle'] ?? '',
        'plate': seededDraft.images['plate'] ?? '',
      });
  }

  DriverProfileDraft _withFallbackDraft(DriverProfileDraft draft) {
    final locale = context.localization;
    final hasRealData = [
      draft.address,
      draft.nationalId,
      draft.licenseNumber,
      draft.vehicleBrand,
      draft.vehicleModel,
      draft.plateNumber,
      ...draft.images.values,
    ].any((value) => value.trim().isNotEmpty);

    if (hasRealData) return draft;

    return draft.copyWith(
      vehicleType: 'bike',
      address: locale.driver_profile_mock_address,
      nationalId: locale.driver_profile_mock_national_id,
      licenseNumber: locale.driver_profile_mock_license_number,
      vehicleBrand: locale.driver_profile_mock_vehicle_brand,
      vehicleModel: locale.driver_profile_mock_vehicle_model,
      plateNumber: locale.driver_profile_mock_plate_number,
      images: {
        'portrait': 'mock/portrait.jpg',
        'idFront': 'mock/id-front.jpg',
        'license': 'mock/license.jpg',
        'vehicle': 'mock/vehicle.jpg',
        'plate': 'mock/plate.jpg',
      },
    );
  }

  Future<void> _pickImage(String key) async {
    final locale = context.localization;
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 86,
      );
      if (image == null || !mounted) return;
      setState(() => _images[key] = image.path);
    } catch (error) {
      if (!mounted) return;
      final message = error.toString().contains('channel-error')
          ? locale.driver_profile_picker_restart_required
          : locale.driver_profile_picker_error;
      CustomSnackbar.showError(context: context, message: message);
    }
  }

  bool _validateCurrentStep() {
    if (_currentStep == 2 || _currentStep == 3) {
      final hasImages = _images.values.every((value) => value.trim().isNotEmpty);
      if (!hasImages) {
        CustomSnackbar.showError(
          context: context,
          message: context.localization.driver_profile_images_required_error,
        );
      }
      if (_currentStep == 2) return hasImages;
      return (_formKey.currentState?.validate() ?? false) && hasImages;
    }

    return _formKey.currentState?.validate() ?? false;
  }

  Future<void> _goNext() async {
    if (!_validateCurrentStep()) return;

    if (_currentStep == _stepTitles(context).length - 1) {
      setState(() => _isSubmitting = true);
      await _service.saveProfileDraft(
        DriverProfileDraft(
          vehicleType: _vehicleType,
          address: _addressController.text.trim(),
          nationalId: _nationalIdController.text.trim(),
          licenseNumber: _licenseNumberController.text.trim(),
          vehicleBrand: _vehicleBrandController.text.trim(),
          vehicleModel: _vehicleModelController.text.trim(),
          plateNumber: _plateNumberController.text.trim(),
          images: Map<String, String>.from(_images),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;

      setState(() => _isSubmitting = false);
      context.pushNamedAndRemoveUntil(
        AppRoutes.accountPendingApproval,
        predicate: (route) => false,
      );
      return;
    }

    setState(() => _currentStep += 1);
  }

  void _goBack() {
    if (_currentStep == 0) {
      context.pop();
      return;
    }
    setState(() => _currentStep -= 1);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;
    final titles = _stepTitles(context);
    final subtitles = _stepSubtitles(context);

    return Scaffold(
      backgroundColor: color.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            Spacing.base,
            Spacing.base,
            Spacing.base,
            Spacing.xl,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PageHeader(
                  title: locale.driver_profile_title,
                  subtitle: locale.driver_profile_page_subtitle,
                  onBack: _goBack,
                ),
                const SizedBox(height: Spacing.base),
                DriverProfileStepsBar(
                  titles: titles,
                  currentStep: _currentStep,
                ),
                const SizedBox(height: Spacing.base),
                DriverProfileStepHeader(
                  title: titles[_currentStep],
                  subtitle: subtitles[_currentStep],
                  step: _currentStep + 1,
                  total: titles.length,
                ),
                const SizedBox(height: Spacing.base),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: KeyedSubtree(
                    key: ValueKey(_currentStep),
                    child: _buildStepContent(context),
                  ),
                ),
                const SizedBox(height: Spacing.lg),
                Row(
                  children: [
                    if (_currentStep > 0) ...[
                      Expanded(
                        child: AppButton.outlined(
                          text: locale.driver_profile_step_back,
                          onPressed: _isSubmitting ? null : _goBack,
                          height: 54,
                          borderRadius: 18,
                        ),
                      ),
                      const SizedBox(width: Spacing.sm),
                    ],
                    Expanded(
                      child: AppButton.filled(
                        text: _currentStep == titles.length - 1
                            ? locale.driver_profile_submit_information
                            : locale.driver_profile_step_next,
                        isLoading: _isSubmitting,
                        onPressed: _isSubmitting ? null : _goNext,
                        height: 54,
                        borderRadius: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    switch (_currentStep) {
      case 0:
        return DriverSectionCard(
          title: locale.driver_profile_identity_card_title,
          subtitle: locale.driver_profile_identity_card_subtitle,
          child: Column(
            children: [
              _buildField(
                context,
                controller: _addressController,
                label: locale.driver_profile_address_label,
                hint: locale.driver_profile_address_hint,
                icon: Icons.home_work_outlined,
              ),
              const SizedBox(height: 12),
              _buildField(
                context,
                controller: _nationalIdController,
                label: locale.driver_profile_national_id_label,
                hint: locale.driver_profile_national_id_hint,
                icon: Icons.badge_outlined,
              ),
              const SizedBox(height: 12),
              _buildField(
                context,
                controller: _licenseNumberController,
                label: locale.driver_profile_license_number_label,
                hint: locale.driver_profile_license_number_hint,
                icon: Icons.assignment_outlined,
              ),
            ],
          ),
        );
      case 1:
        return DriverSectionCard(
          title: locale.driver_profile_vehicle_card_title,
          subtitle: locale.driver_profile_vehicle_card_subtitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DriverVehicleTypeSelector(
                selectedType: _vehicleType,
                onChanged: (value) => setState(() => _vehicleType = value),
              ),
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
                      _vehicleType == 'bike'
                          ? Icons.route_outlined
                          : Icons.inventory_2_outlined,
                      color: color.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _vehicleType == 'bike'
                            ? locale.driver_profile_vehicle_selected_bike_message
                            : locale.driver_profile_vehicle_selected_car_message,
                        style: getRegularStyle(
                          fontFamily: FontConstant.cairo,
                          color: color.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _buildField(
                context,
                controller: _vehicleBrandController,
                label: locale.driver_profile_brand_label,
                hint: locale.driver_profile_brand_hint,
                icon: Icons.directions_car_outlined,
              ),
              const SizedBox(height: 12),
              _buildField(
                context,
                controller: _vehicleModelController,
                label: locale.driver_profile_model_label,
                hint: locale.driver_profile_model_hint,
                icon: Icons.tune_rounded,
              ),
              const SizedBox(height: 12),
              _buildField(
                context,
                controller: _plateNumberController,
                label: locale.driver_profile_plate_label,
                hint: locale.driver_profile_plate_hint,
                icon: Icons.pin_outlined,
              ),
            ],
          ),
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _UploadsOverview(images: _images, vehicleType: _vehicleType),
            const SizedBox(height: Spacing.base),
            DriverSectionCard(
              title: locale.driver_profile_uploads_card_title,
              subtitle: locale.driver_profile_uploads_card_subtitle,
              child: Column(
                children: [
                  _buildUploadTile(
                    context,
                    'portrait',
                    locale.driver_profile_portrait_title,
                    locale.driver_profile_portrait_subtitle,
                    Icons.person_rounded,
                  ),
                  const SizedBox(height: 8),
                  _buildUploadTile(
                    context,
                    'idFront',
                    locale.driver_profile_id_front_title,
                    locale.driver_profile_id_front_subtitle,
                    Icons.badge_outlined,
                  ),
                  const SizedBox(height: 8),
                  _buildUploadTile(
                    context,
                    'license',
                    locale.driver_profile_license_title,
                    locale.driver_profile_license_subtitle,
                    Icons.assignment_ind_outlined,
                  ),
                  const SizedBox(height: 8),
                  _buildUploadTile(
                    context,
                    'vehicle',
                    locale.driver_profile_vehicle_photo_title,
                    locale.driver_profile_vehicle_photo_subtitle,
                    _vehicleType == 'bike'
                        ? Icons.two_wheeler_outlined
                        : Icons.local_shipping_outlined,
                  ),
                  const SizedBox(height: 8),
                  _buildUploadTile(
                    context,
                    'plate',
                    locale.driver_profile_plate_photo_title,
                    locale.driver_profile_plate_photo_subtitle,
                    Icons.photo_camera_back_outlined,
                  ),
                ],
              ),
            ),
          ],
        );
      default:
        final uploadedCount = _images.values
            .where((value) => value.trim().isNotEmpty)
            .length;

        return DriverSectionCard(
          title: locale.driver_profile_review_card_title,
          subtitle: locale.driver_profile_review_card_subtitle,
          child: DriverProfileReviewList(
            items: [
              (
                label: locale.driver_profile_address_label,
                value: _addressController.text,
              ),
              (
                label: locale.driver_profile_national_id_label,
                value: _nationalIdController.text,
              ),
              (
                label: locale.driver_profile_license_number_label,
                value: _licenseNumberController.text,
              ),
              (
                label: locale.driver_profile_vehicle_type_label,
                value: _vehicleType == 'bike'
                    ? locale.driver_profile_vehicle_type_bike
                    : locale.driver_profile_vehicle_type_car,
              ),
              (
                label: locale.driver_profile_brand_review_label,
                value: _vehicleBrandController.text,
              ),
              (
                label: locale.driver_profile_model_review_label,
                value: _vehicleModelController.text,
              ),
              (
                label: locale.driver_profile_plate_review_label,
                value: _plateNumberController.text,
              ),
              (
                label: locale.driver_profile_uploaded_images_label,
                value: '$uploadedCount/5',
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
  }) {
    final color = context.colorScheme;

    return AuthTextField(
      controller: controller,
      label: label,
      hintText: hint,
      validator: (value) => Validations.validateRequired(context, value),
      enabled: !_isSubmitting,
      prefixIcon: Icon(icon, color: color.onSurface.withValues(alpha: 0.6)),
    );
  }

  Widget _buildUploadTile(
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
      imagePath: _images[key],
      onTap: () => _pickImage(key),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          style: IconButton.styleFrom(
            backgroundColor: color.surfaceContainerLow,
            foregroundColor: color.onSurface,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size24,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  color: color.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UploadsOverview extends StatelessWidget {
  const _UploadsOverview({required this.images, required this.vehicleType});

  final Map<String, String> images;
  final String vehicleType;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final uploadedCount = images.values
        .where((value) => value.trim().isNotEmpty)
        .length;

    return Row(
      children: [
        Expanded(
          child: _OverviewCard(
            icon: Icons.image_outlined,
            label: locale.driver_profile_uploaded_images_label,
            value: '$uploadedCount/5',
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: _OverviewCard(
            icon: Icons.speed_rounded,
            label: locale.driver_profile_vehicle_type_label,
            value: vehicleType == 'bike'
                ? locale.driver_profile_vehicle_type_bike
                : locale.driver_profile_vehicle_type_car,
          ),
        ),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color.primary, size: 20),
          const SizedBox(height: 10),
          Text(
            label,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size11,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size15,
              color: color.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
