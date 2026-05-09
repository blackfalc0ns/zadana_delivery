import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/document_expiry_date_helper.dart';
import 'package:zadana_delivery/core/utils/driver_vehicle_type.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/profile/domain/entities/update_driver_vehicle_request_entity.dart';
import 'package:zadana_delivery/features/profile/presentation/manager/profile_cubit.dart';
import 'package:zadana_delivery/features/profile/presentation/manager/profile_form_event.dart';
import 'package:zadana_delivery/features/profile/presentation/manager/profile_state.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_form_scaffold.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_loading_skeleton.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/vehicle_info_fields.dart';

class VehicleInfoScreen extends StatefulWidget {
  const VehicleInfoScreen({super.key});

  @override
  State<VehicleInfoScreen> createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  late final ProfileCubit _cubit;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nationalIdController;
  late final TextEditingController _licenseController;
  late final TextEditingController _nationalIdExpiryController;
  late final TextEditingController _driverLicenseExpiryController;
  late final TextEditingController _vehicleLicenseNumberController;
  late final TextEditingController _vehicleLicenseExpiryController;
  String _vehicleType = DriverVehicleType.car;
  String _selectedCityId = '';
  String _selectedRegionCode = '';
  String _selectedCityName = '';
  String _selectedRegionName = '';
  bool _didSeedControllers = false;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ProfileCubit>()
      ..doIntent(const ProfileFormLoadEvent(includeRegionCities: true));
    _nationalIdController = TextEditingController();
    _licenseController = TextEditingController();
    _nationalIdExpiryController = TextEditingController();
    _driverLicenseExpiryController = TextEditingController();
    _vehicleLicenseNumberController = TextEditingController();
    _vehicleLicenseExpiryController = TextEditingController();
    _nationalIdController.addListener(_cubit.clearError);
    _licenseController.addListener(_cubit.clearError);
    _nationalIdExpiryController.addListener(_cubit.clearError);
    _driverLicenseExpiryController.addListener(_cubit.clearError);
    _vehicleLicenseNumberController.addListener(_cubit.clearError);
    _vehicleLicenseExpiryController.addListener(_cubit.clearError);
  }

  @override
  void dispose() {
    _nationalIdController.dispose();
    _licenseController.dispose();
    _nationalIdExpiryController.dispose();
    _driverLicenseExpiryController.dispose();
    _vehicleLicenseNumberController.dispose();
    _vehicleLicenseExpiryController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          final profile = state.profile;
          if (!_didSeedControllers && profile != null) {
            _didSeedControllers = true;
            _vehicleType = DriverVehicleType.normalize(profile.vehicleType);
            _nationalIdController.text = profile.nationalId;
            _licenseController.text = profile.licenseNumber;
            _nationalIdExpiryController.text =
                DocumentExpiryDateHelper.toFormValue(
                  profile.nationalIdExpiryDate,
                );
            _driverLicenseExpiryController.text =
                DocumentExpiryDateHelper.toFormValue(
                  profile.driverLicenseExpiryDate,
                );
            _vehicleLicenseNumberController.text = profile.vehicleLicenseNumber;
            _vehicleLicenseExpiryController.text =
                DocumentExpiryDateHelper.toFormValue(
                  profile.vehicleLicenseExpiryDate,
                );
            _selectedCityId = profile.city;
            _selectedRegionCode = profile.region;
            _selectedCityName = profile.displayCityName;
            _selectedRegionName = profile.displayRegionName;
          }

          if (state.isSuccess) {
            CustomSnackbar.showSuccess(
              context: context,
              message: context.localization.profile_vehicle_info_saved,
            );
            Navigator.of(context).pop();
            return;
          }

          if (state.failure != null && state.profile != null) {
            if (state.failure!.isConnectivityIssue) return;
            CustomSnackbar.showError(
              context: context,
              message: state.failure!.errorMessage,
            );
            _cubit.clearError();
          }
        },
        builder: (context, state) {
          final showGlobalError =
              !state.isLoading &&
              state.profile == null &&
              state.failure != null;

          if (state.profile == null && state.isLoading) {
            return ProfileFormLoadingSkeleton(
              title: locale.driver_profile_vehicle_card_title,
              fieldCount: 3,
              includeSelector: true,
            );
          }

          if (showGlobalError) {
            return Scaffold(
              backgroundColor: context.colorScheme.surface,
              body: SafeArea(
                child: ApiErrorWidget(
                  exception: state.failure!.asException,
                  onRetry: () => _cubit.doIntent(
                    const ProfileFormLoadEvent(includeRegionCities: true),
                  ),
                  onGoBack: () =>
                      _cubit.doIntent(const ProfileFormClearErrorEvent()),
                ),
              ),
            );
          }

          return ProfileFormScaffold(
            title: locale.driver_profile_vehicle_card_title,
            headerTitle: locale.driver_profile_vehicle_card_title,
            headerSubtitle: locale.driver_profile_vehicle_card_subtitle,
            headerIcon: Icons.directions_bike_outlined,
            headerColorToken: ProfileColorToken.secondary,
            formKey: _formKey,
            isSaving: state.isSaving || state.isLoading,
            onSave: _save,
            children: [
              VehicleInfoFields(
                groupValue: _vehicleType,
                onTypeChanged: _selectType,
                nationalIdController: _nationalIdController,
                licenseController: _licenseController,
                nationalIdExpiryController: _nationalIdExpiryController,
                driverLicenseExpiryController: _driverLicenseExpiryController,
                vehicleLicenseNumberController: _vehicleLicenseNumberController,
                vehicleLicenseExpiryController: _vehicleLicenseExpiryController,
                regionCities: state.regionCities,
                isRegionCitiesLoading: state.isRegionCitiesLoading,
                selectedCityId: _selectedCityId,
                selectedRegionCode: _selectedRegionCode,
                selectedCityName: _selectedCityName,
                selectedRegionName: _selectedRegionName,
                regionCitiesFailure: state.regionCitiesFailure,
                onRetryRegionCities: () =>
                    _cubit.doIntent(const ProfileFormRetryRegionCitiesEvent()),
                onRegionCityChanged: (regionCity) {
                  setState(() {
                    _selectedCityId = regionCity.id;
                    _selectedRegionCode = regionCity.regionCode;
                    _selectedCityName = regionCity.cityName;
                    _selectedRegionName = regionCity.regionName;
                  });
                  _cubit.clearError();
                },
                onPickDate: _pickDate,
              ),
            ],
          );
        },
      ),
    );
  }

  void _selectType(String value) {
    setState(() => _vehicleType = value);
    _cubit.clearError();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedCityId.trim().isEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: context.localization.driver_profile_zone_required_error,
      );
      return;
    }
    final documentPaths = _cubit.state.documentPaths;
    if ((documentPaths['idFront'] ?? '').trim().isEmpty ||
        (documentPaths['idBack'] ?? '').trim().isEmpty ||
        (documentPaths['license'] ?? '').trim().isEmpty ||
        (documentPaths['vehicle'] ?? '').trim().isEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: context.localization.driver_profile_images_required_error,
      );
      return;
    }

    await _cubit.doIntent(
      ProfileFormSaveVehicleEvent(
        UpdateDriverVehicleRequestEntity(
          vehicleType: _vehicleType,
          nationalId: _nationalIdController.text.trim(),
          licenseNumber: _licenseController.text.trim(),
          nationalIdExpiryDate: _nationalIdExpiryController.text.trim(),
          driverLicenseExpiryDate: _driverLicenseExpiryController.text.trim(),
          vehicleLicenseNumber: _vehicleLicenseNumberController.text.trim(),
          vehicleLicenseExpiryDate: _vehicleLicenseExpiryController.text.trim(),
          region: _selectedRegionCode,
          city: _selectedCityId,
        ),
      ),
    );
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final initialDate =
        DocumentExpiryDateHelper.tryParse(controller.text) ??
        DateTime.now().add(const Duration(days: 365));
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(now) ? now : initialDate,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 25),
    );
    if (picked == null) return;

    controller.text = DocumentExpiryDateHelper.formatForDisplay(
      picked.toIso8601String(),
    );
  }
}
