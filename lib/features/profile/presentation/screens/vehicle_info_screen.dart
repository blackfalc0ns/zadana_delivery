import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
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
  String _vehicleType = DriverVehicleType.car;
  String _selectedZoneId = '';
  String _selectedRegionCode = '';
  String _selectedZoneName = '';
  String _selectedZoneCity = '';
  bool _didSeedControllers = false;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ProfileCubit>()
      ..doIntent(const ProfileFormLoadEvent(includeZones: true));
    _nationalIdController = TextEditingController();
    _licenseController = TextEditingController();
    _nationalIdController.addListener(_cubit.clearError);
    _licenseController.addListener(_cubit.clearError);
  }

  @override
  void dispose() {
    _nationalIdController.dispose();
    _licenseController.dispose();
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
            _selectedZoneId = profile.primaryZoneId;
            _selectedRegionCode = '';
            _selectedZoneName = profile.zoneName;
            _selectedZoneCity = '';
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
                    const ProfileFormLoadEvent(includeZones: true),
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
                zones: state.zones,
                isZonesLoading: state.isZonesLoading,
                selectedZoneId: _selectedZoneId,
                selectedRegionCode: _selectedRegionCode,
                selectedZoneName: _selectedZoneName,
                selectedZoneCity: _selectedZoneCity,
                zonesFailure: state.zonesFailure,
                onRetryZones: () =>
                    _cubit.doIntent(const ProfileFormRetryZonesEvent()),
                onZoneChanged: (zone) {
                  setState(() {
                    _selectedZoneId = zone.id;
                    _selectedRegionCode = zone.regionCode;
                    _selectedZoneName = zone.name;
                    _selectedZoneCity = zone.city;
                  });
                  _cubit.clearError();
                },
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
    if (_selectedZoneId.trim().isEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: context.localization.driver_profile_zone_required_error,
      );
      return;
    }

    await _cubit.doIntent(
      ProfileFormSaveVehicleEvent(
        UpdateDriverVehicleRequestEntity(
          vehicleType: _vehicleType,
          nationalId: _nationalIdController.text,
          licenseNumber: _licenseController.text,
          primaryZoneId: _selectedZoneId,
        ),
      ),
    );
  }
}
