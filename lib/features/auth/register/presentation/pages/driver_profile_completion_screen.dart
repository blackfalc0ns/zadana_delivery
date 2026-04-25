import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/validators.dart';
import 'package:zadana_delivery/core/utils/driver_vehicle_type.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/auth/auth_text_field.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/auth/data/driver_profile_service.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/register_request_entity.dart';
import 'package:zadana_delivery/features/auth/register/presentation/manager/register_event.dart';
import 'package:zadana_delivery/features/auth/register/presentation/manager/register_state.dart';
import 'package:zadana_delivery/features/auth/register/presentation/manager/register_view_model.dart';
import 'package:zadana_delivery/features/auth/register/presentation/manager/register_zones_cubit.dart';
import 'package:zadana_delivery/features/auth/register/presentation/manager/register_zones_state.dart';
import 'package:zadana_delivery/features/auth/register/presentation/models/register_account_draft.dart';
import 'package:zadana_delivery/features/auth/register/presentation/models/register_profile_draft.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_profile/driver_profile_review_list.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_profile/driver_profile_step_header.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_profile/driver_profile_steps_bar.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_profile/driver_vehicle_type_selector.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_profile/driver_zone_selector.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_section_card.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_upload_tile.dart';

class DriverProfileCompletionScreen extends StatefulWidget {
  const DriverProfileCompletionScreen({super.key, this.registrationDraft});

  final RegisterAccountDraft? registrationDraft;

  @override
  State<DriverProfileCompletionScreen> createState() =>
      _DriverProfileCompletionScreenState();
}

class _DriverProfileCompletionScreenState
    extends State<DriverProfileCompletionScreen> {
  final _draftService = getIt<DriverProfileDraftService>();
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _imagePicker = getIt<ImagePicker>();
  final _images = <String, String>{
    'portrait': '',
    'idFront': '',
    'license': '',
    'vehicle': '',
  };

  late final RegisterViewModel _cubit;
  late final RegisterZonesCubit _zonesCubit;
  int _currentStep = 0;
  bool _didLoadInitialData = false;
  String _vehicleType = '';
  String _zoneId = '';
  String _zoneName = '';
  String _zoneCity = '';

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
    _cubit = getIt<RegisterViewModel>();
    _zonesCubit = getIt<RegisterZonesCubit>();
    for (final controller in [
      _addressController,
      _nationalIdController,
      _licenseNumberController,
    ]) {
      controller.addListener(_onFormChanged);
    }
    if (widget.registrationDraft != null) {
      _zonesCubit.loadZones();
    }
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
    _cubit.close();
    _zonesCubit.close();
    _addressController.dispose();
    _nationalIdController.dispose();
    _licenseNumberController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    final seededDraft = widget.registrationDraft == null
        ? _profileDraftToRegisterDraft(_draftService.profileDraft)
        : _cubit.state.draft;
    _cubit.seedDraft(seededDraft);
    _applyDraftToInputs(seededDraft);
  }

  RegisterProfileDraft _profileDraftToRegisterDraft(DriverProfileDraft draft) {
    return RegisterProfileDraft(
      vehicleType: draft.vehicleType,
      zoneId: '',
      zoneName: '',
      zoneCity: '',
      address: draft.address,
      nationalId: draft.nationalId,
      licenseNumber: draft.licenseNumber,
      images: {
        'portrait': draft.images['portrait'] ?? '',
        'idFront': draft.images['idFront'] ?? '',
        'license': draft.images['license'] ?? '',
        'vehicle': draft.images['vehicle'] ?? '',
      },
    );
  }

  void _applyDraftToInputs(RegisterProfileDraft draft) {
    _vehicleType = draft.vehicleType.trim().isEmpty
        ? ''
        : DriverVehicleType.normalize(draft.vehicleType);
    _zoneId = draft.zoneId;
    _zoneName = draft.zoneName;
    _zoneCity = draft.zoneCity;
    _addressController.text = draft.address;
    _nationalIdController.text = draft.nationalId;
    _licenseNumberController.text = draft.licenseNumber;
    _images
      ..clear()
      ..addAll({
        'portrait': draft.images['portrait'] ?? '',
        'idFront': draft.images['idFront'] ?? '',
        'license': draft.images['license'] ?? '',
        'vehicle': draft.images['vehicle'] ?? '',
      });
  }

  void _onFormChanged() {
    _cubit.clearError();
    _syncDraftToState();
  }

  RegisterProfileDraft _buildCurrentDraft() {
    return RegisterProfileDraft(
      vehicleType: _vehicleType.trim().isEmpty
          ? ''
          : DriverVehicleType.normalize(_vehicleType),
      zoneId: _zoneId,
      zoneName: _zoneName,
      zoneCity: _zoneCity,
      address: _addressController.text.trim(),
      nationalId: _nationalIdController.text.trim(),
      licenseNumber: _licenseNumberController.text.trim(),
      images: {
        'portrait': _images['portrait'] ?? '',
        'idFront': _images['idFront'] ?? '',
        'license': _images['license'] ?? '',
        'vehicle': _images['vehicle'] ?? '',
      },
    );
  }

  void _syncDraftToState() {
    _cubit.updateDraft(_buildCurrentDraft());
  }

  Future<void> _pickImage(String key) async {
    final locale = context.localization;
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 86,
      );
      if (image == null || !mounted) return;
      _cubit.clearError();
      setState(() => _images[key] = image.path);
      _syncDraftToState();
    } catch (error) {
      if (!mounted) return;
      final message = error.toString().contains('channel-error')
          ? locale.driver_profile_picker_restart_required
          : locale.driver_profile_picker_error;
      CustomSnackbar.showError(context: context, message: message);
    }
  }

  bool _validateCurrentStep() {
    if (_currentStep == 1 && _vehicleType.trim().isEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: context.localization.driver_profile_vehicle_required_error,
      );
      return false;
    }

    if (_currentStep == 1 && widget.registrationDraft != null) {
      if (_zoneId.trim().isEmpty) {
        CustomSnackbar.showError(
          context: context,
          message: context.localization.driver_profile_zone_required_error,
        );
        return false;
      }
    }

    if (_currentStep == 2 || _currentStep == 3) {
      final hasImages = _hasRequiredImages();
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

  bool _hasRequiredImages() {
    return _images.values.every((value) {
      final path = value.trim();
      return path.isNotEmpty && File(path).existsSync();
    });
  }

  Future<void> _goNext() async {
    if (!_validateCurrentStep()) return;

    if (_currentStep == _stepTitles(context).length - 1) {
      await _submitProfile();
      return;
    }

    setState(() => _currentStep += 1);
  }

  Future<void> _submitProfile() async {
    final draft = _buildCurrentDraft();
    _cubit.updateDraft(draft);
    await _submitProfileWithDraft(draft);
  }

  Future<void> _submitProfileWithDraft(RegisterProfileDraft draft) async {
    final registrationDraft = widget.registrationDraft;
    if (registrationDraft == null) {
      await _draftService.saveProfileDraft(
        DriverProfileDraft(
          vehicleType: draft.vehicleType,
          address: draft.address,
          nationalId: draft.nationalId,
          licenseNumber: draft.licenseNumber,
          vehicleBrand: '',
          vehicleModel: '',
          plateNumber: '',
          images: draft.images,
        ),
      );
      if (!mounted) return;
      context.pushNamedAndRemoveUntil(
        AppRoutes.accountPendingApproval,
        predicate: (route) => false,
      );
      return;
    }

    await _cubit.doIntent(
      RegisterSubmitEvent(
        RegisterRequestEntity(
          fullName: registrationDraft.fullName,
          email: registrationDraft.email,
          phone: registrationDraft.phone,
          password: registrationDraft.password,
          vehicleType: _vehicleType,
          nationalId: draft.nationalId,
          licenseNumber: draft.licenseNumber,
          address: draft.address,
          primaryZoneId: draft.zoneId,
          nationalIdImagePath: _images['idFront'] ?? '',
          licenseImagePath: _images['license'] ?? '',
          vehicleImagePath: _images['vehicle'] ?? '',
          personalPhotoPath: _images['portrait'] ?? '',
        ),
      ),
    );
  }

  Future<void> _retryCurrentAction() async {
    final registrationDraft = widget.registrationDraft;
    final draft = _buildCurrentDraft();
    final hasAnyEntry =
        draft.address.isNotEmpty ||
        draft.nationalId.isNotEmpty ||
        draft.licenseNumber.isNotEmpty ||
        draft.zoneId.isNotEmpty ||
        draft.images.values.any((value) => value.trim().isNotEmpty);

    if (registrationDraft == null && !hasAnyEntry) {
      _cubit.clearError();
      return;
    }

    if (registrationDraft != null &&
        (registrationDraft.fullName.trim().isEmpty ||
            registrationDraft.phone.trim().isEmpty ||
            registrationDraft.password.isEmpty)) {
      _cubit.clearError();
      return;
    }

    await _submitProfileWithDraft(draft);
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

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cubit),
        BlocProvider.value(value: _zonesCubit),
      ],
      child: BlocConsumer<RegisterViewModel, RegisterState>(
        listener: (context, state) {
          if (state.isSuccess && state.response != null) {
            CustomSnackbar.showSuccess(
              context: context,
              message: state.response!.message,
            );
            context.pushNamedAndRemoveUntil(
              AppRoutes.accountPendingApproval,
              predicate: (route) => false,
            );
          }
        },
        builder: (context, state) {
          final isSubmitting = state.isLoading;
          final failure = state.failure;

          if (!isSubmitting && failure != null) {
            return Scaffold(
              backgroundColor: color.surface,
              body: SafeArea(
                child: ApiErrorWidget.fromFailure(
                  failure,
                  onRetry: _retryCurrentAction,
                  onGoBack: _cubit.clearError,
                ),
              ),
            );
          }

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
                          child: _buildStepContent(context, isSubmitting),
                        ),
                      ),
                      const SizedBox(height: Spacing.lg),
                      Row(
                        children: [
                          if (_currentStep > 0) ...[
                            Expanded(
                              child: AppButton.outlined(
                                text: locale.driver_profile_step_back,
                                onPressed: isSubmitting ? null : _goBack,
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
                              isLoading: isSubmitting,
                              onPressed: isSubmitting ? null : _goNext,
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
        },
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, bool isSubmitting) {
    final locale = context.localization;
    final color = context.colorScheme;
    final hasSelectedVehicle = _vehicleType.trim().isNotEmpty;
    final normalizedVehicleType = hasSelectedVehicle
        ? DriverVehicleType.normalize(_vehicleType)
        : '';

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
                isSubmitting: isSubmitting,
              ),
              const SizedBox(height: 12),
              _buildField(
                context,
                controller: _nationalIdController,
                label: locale.driver_profile_national_id_label,
                hint: locale.driver_profile_national_id_hint,
                icon: Icons.badge_outlined,
                isSubmitting: isSubmitting,
              ),
              const SizedBox(height: 12),
              _buildField(
                context,
                controller: _licenseNumberController,
                label: locale.driver_profile_license_number_label,
                hint: locale.driver_profile_license_number_hint,
                icon: Icons.assignment_outlined,
                isSubmitting: isSubmitting,
              ),
            ],
          ),
        );
      case 1:
        return BlocBuilder<RegisterZonesCubit, RegisterZonesState>(
          builder: (context, zonesState) {
            return DriverSectionCard(
              title: locale.driver_profile_vehicle_card_title,
              subtitle: locale.driver_profile_vehicle_card_subtitle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DriverVehicleTypeSelector(
                    selectedType: _vehicleType,
                    onChanged: (value) {
                      if (isSubmitting) return;
                      _cubit.clearError();
                      setState(() => _vehicleType = value);
                      _syncDraftToState();
                    },
                  ),
                  if (widget.registrationDraft != null) ...[
                    const SizedBox(height: 14),
                    DriverZoneSelector(
                      zones: zonesState.zones,
                      isLoading: zonesState.isLoading,
                      selectedZoneId: _zoneId,
                      selectedZoneName: _zoneName,
                      selectedZoneCity: _zoneCity,
                      errorMessage: zonesState.failure?.errorMessage,
                      onRetry: () => _zonesCubit.loadZones(),
                      onChanged: (zone) {
                        if (isSubmitting) return;
                        _cubit.clearError();
                        setState(() {
                          _zoneId = zone.id;
                          _zoneName = zone.name;
                          _zoneCity = zone.city;
                        });
                        _syncDraftToState();
                      },
                    ),
                  ],
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
                _vehicleTypeIcon(normalizedVehicleType),
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
                value: hasSelectedVehicle
                    ? _vehicleTypeLabel(context, normalizedVehicleType)
                    : locale.driver_profile_incomplete,
              ),
              if (widget.registrationDraft != null)
                (
                  label: locale.driver_profile_zone_label,
                  value: _zoneName.isEmpty
                      ? locale.driver_profile_incomplete
                      : '$_zoneName, $_zoneCity',
                ),
              (
                label: locale.driver_profile_portrait_title,
                value: _images['portrait'] ?? '',
              ),
              (
                label: locale.driver_profile_id_front_title,
                value: _images['idFront'] ?? '',
              ),
              (
                label: locale.driver_profile_license_title,
                value: _images['license'] ?? '',
              ),
              (
                label: locale.driver_profile_vehicle_photo_title,
                value: _images['vehicle'] ?? '',
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
