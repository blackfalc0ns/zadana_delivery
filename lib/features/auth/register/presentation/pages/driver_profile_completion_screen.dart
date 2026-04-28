import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_presentation.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/auth/register/domain/usecase/register_usecase.dart';
import 'package:zadana_delivery/features/auth/register/presentation/manager/driver_profile_completion_cubit.dart';
import 'package:zadana_delivery/features/auth/register/presentation/manager/driver_profile_completion_state.dart';
import 'package:zadana_delivery/features/auth/register/presentation/manager/register_zones_cubit.dart';
import 'package:zadana_delivery/features/auth/register/presentation/models/register_account_draft.dart';
import 'package:zadana_delivery/features/auth/register/presentation/models/register_profile_draft.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_profile/driver_profile_completion_content.dart';
import 'package:zadana_delivery/features/profile/domain/usecase/get_driver_unified_profile_usecase.dart';
import 'package:zadana_delivery/features/profile/domain/usecase/update_driver_documents_usecase.dart';
import 'package:zadana_delivery/features/profile/domain/usecase/update_driver_personal_usecase.dart';
import 'package:zadana_delivery/features/profile/domain/usecase/update_driver_vehicle_usecase.dart';

class DriverProfileCompletionScreen extends StatefulWidget {
  const DriverProfileCompletionScreen({super.key, this.registrationDraft});

  final RegisterAccountDraft? registrationDraft;

  @override
  State<DriverProfileCompletionScreen> createState() =>
      _DriverProfileCompletionScreenState();
}

class _DriverProfileCompletionScreenState
    extends State<DriverProfileCompletionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  bool _didSeedControllers = false;

  late final DriverProfileCompletionCubit _cubit;
  late final RegisterZonesCubit _zonesCubit;

  @override
  void initState() {
    super.initState();
    _cubit = DriverProfileCompletionCubit(
      registerUseCase: getIt<RegisterUseCase>(),
      getProfileUseCase: getIt<GetDriverUnifiedProfileUseCase>(),
      updatePersonalUseCase: getIt<UpdateDriverPersonalUseCase>(),
      updateVehicleUseCase: getIt<UpdateDriverVehicleUseCase>(),
      updateDocumentsUseCase: getIt<UpdateDriverDocumentsUseCase>(),
      imagePicker: getIt(),
    )..initialize(registrationDraft: widget.registrationDraft);
    _zonesCubit = getIt<RegisterZonesCubit>()..loadZones();

    for (final controller in [
      _addressController,
      _nationalIdController,
      _licenseNumberController,
    ]) {
      controller.addListener(_onFormChanged);
    }
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

  void _applyDraftToInputs(RegisterProfileDraft draft) {
    _addressController.text = draft.address;
    _nationalIdController.text = draft.nationalId;
    _licenseNumberController.text = draft.licenseNumber;
  }

  RegisterProfileDraft _buildCurrentDraft() {
    final currentDraft = _cubit.state.draft;
    return RegisterProfileDraft(
      vehicleType: currentDraft.vehicleType,
      zoneId: currentDraft.zoneId,
      zoneRegionCode: currentDraft.zoneRegionCode,
      zoneName: currentDraft.zoneName,
      zoneCity: currentDraft.zoneCity,
      address: _addressController.text.trim(),
      nationalId: _nationalIdController.text.trim(),
      licenseNumber: _licenseNumberController.text.trim(),
      images: currentDraft.images,
    );
  }

  void _onFormChanged() {
    _cubit.updateDraft(_buildCurrentDraft());
  }

  Future<void> _pickImage(String key) async {
    final locale = context.localization;
    final message = await _cubit.pickImage(
      key: key,
      restartRequiredMessage: locale.driver_profile_picker_restart_required,
      pickerErrorMessage: locale.driver_profile_picker_error,
    );
    if (!mounted || (message ?? '').isEmpty) return;
    CustomSnackbar.showError(context: context, message: message!);
  }

  Future<void> _goNext() async {
    final currentStep = _cubit.state.currentStep;
    final needsFormValidation = currentStep == 0 || currentStep == 3;
    final message = await _cubit.goNext(
      isFormValid:
          !needsFormValidation || (_formKey.currentState?.validate() ?? false),
      vehicleRequiredMessage:
          context.localization.driver_profile_vehicle_required_error,
      zoneRequiredMessage:
          context.localization.driver_profile_zone_required_error,
      imagesRequiredMessage:
          context.localization.driver_profile_images_required_error,
      profileSuccessMessage: context.localization.driver_profile_submit_success,
    );
    if (!mounted || (message ?? '').isEmpty) return;
    CustomSnackbar.showError(context: context, message: message!);
  }

  Future<void> _retryCurrentAction() {
    return _cubit.retry(
      profileSuccessMessage: context.localization.driver_profile_submit_success,
    );
  }

  void _goBack() {
    if (!_cubit.goBack()) {
      context.pop();
    }
  }

  void _seedControllersOnce(DriverProfileCompletionState state) {
    if (_didSeedControllers || !state.isInitialized) return;
    _didSeedControllers = true;
    _applyDraftToInputs(state.draft);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cubit),
        BlocProvider.value(value: _zonesCubit),
      ],
      child:
          BlocConsumer<
            DriverProfileCompletionCubit,
            DriverProfileCompletionState
          >(
            listenWhen: (previous, current) =>
                previous.isInitialized != current.isInitialized ||
                previous.targetRoute != current.targetRoute ||
                previous.successMessage != current.successMessage ||
                previous.failure != current.failure,
            listener: (context, state) {
              _seedControllersOnce(state);

              if ((state.successMessage ?? '').trim().isEmpty ||
                  (state.targetRoute ?? '').trim().isEmpty) {
                final exception = state.failure?.asException;
                if (!state.isLoading &&
                    exception != null &&
                    exception.errorType.showSnackBar) {
                  CustomSnackbar.showError(
                    context: context,
                    message: ErrorMessagePresenter.snackBarMessage(
                      context,
                      exception,
                    ),
                  );
                }
                return;
              }

              CustomSnackbar.showSuccess(
                context: context,
                message: state.successMessage!,
              );
              context.pushNamedAndRemoveUntil(
                state.targetRoute!,
                rootNavigator: true,
                predicate: (route) => false,
              );
            },
            builder: (context, state) {
              _seedControllersOnce(state);

              final exception = state.failure?.asException;
              if (!state.isLoading &&
                  exception != null &&
                  exception.errorType.showFullScreen) {
                return Scaffold(
                  backgroundColor: color.surface,
                  body: SafeArea(
                    child: ApiErrorWidget(
                      exception: exception,
                      onRetry: _retryCurrentAction,
                      onGoBack: _cubit.clearFailure,
                    ),
                  ),
                );
              }

              return Scaffold(
                body: Stack(
                  children: [
                    SafeArea(
                      child: DriverProfileCompletionContent(
                        formKey: _formKey,
                        state: state,
                        addressController: _addressController,
                        nationalIdController: _nationalIdController,
                        licenseNumberController: _licenseNumberController,
                        onBack: _goBack,
                        onNext: _goNext,
                        onVehicleTypeChanged: _cubit.updateVehicleType,
                        onZoneChanged: _cubit.updateZone,
                        onPickImage: _pickImage,
                      ),
                    ),
                    if (state.isLoading) ...[
                      Positioned.fill(
                        child: AbsorbPointer(
                          child: ColoredBox(
                            color: Colors.black.withValues(alpha: 0.10),
                          ),
                        ),
                      ),
                      const Positioned.fill(child: CustomProgressIndicator()),
                    ],
                  ],
                ),
              );
            },
          ),
    );
  }
}
