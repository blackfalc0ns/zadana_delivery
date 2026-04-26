import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/features/auth/register/domain/entities/driver_zone_entity.dart';
import 'package:zadana_delivery/features/auth/register/presentation/manager/driver_profile_completion_state.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_profile/driver_profile_completion_page_header.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_profile/driver_profile_completion_step_content.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_profile/driver_profile_step_header.dart';
import 'package:zadana_delivery/features/auth/register/presentation/widget/driver_profile/driver_profile_steps_bar.dart';

class DriverProfileCompletionContent extends StatelessWidget {
  const DriverProfileCompletionContent({
    super.key,
    required this.formKey,
    required this.state,
    required this.addressController,
    required this.nationalIdController,
    required this.licenseNumberController,
    required this.onBack,
    required this.onNext,
    required this.onVehicleTypeChanged,
    required this.onZoneChanged,
    required this.onPickImage,
  });

  final GlobalKey<FormState> formKey;
  final DriverProfileCompletionState state;
  final TextEditingController addressController;
  final TextEditingController nationalIdController;
  final TextEditingController licenseNumberController;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final ValueChanged<String> onVehicleTypeChanged;
  final ValueChanged<DriverZoneEntity> onZoneChanged;
  final ValueChanged<String> onPickImage;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final titles = [
      locale.driver_profile_step_identity_title,
      locale.driver_profile_step_vehicle_title,
      locale.driver_profile_step_uploads_title,
      locale.driver_profile_step_submit_title,
    ];
    final subtitles = [
      locale.driver_profile_step_identity_subtitle,
      locale.driver_profile_step_vehicle_subtitle,
      locale.driver_profile_step_uploads_subtitle,
      locale.driver_profile_step_submit_subtitle,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        Spacing.base,
        Spacing.base,
        Spacing.base,
        Spacing.xl,
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DriverProfileCompletionPageHeader(
              title: locale.driver_profile_title,
              subtitle: locale.driver_profile_page_subtitle,
              onBack: onBack,
            ),
            const SizedBox(height: Spacing.base),
            DriverProfileStepsBar(
              titles: titles,
              currentStep: state.currentStep,
            ),
            const SizedBox(height: Spacing.base),
            DriverProfileStepHeader(
              title: titles[state.currentStep],
              subtitle: subtitles[state.currentStep],
              step: state.currentStep + 1,
              total: titles.length,
            ),
            const SizedBox(height: Spacing.base),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: KeyedSubtree(
                key: ValueKey(state.currentStep),
                child: DriverProfileCompletionStepContent(
                  state: state,
                  addressController: addressController,
                  nationalIdController: nationalIdController,
                  licenseNumberController: licenseNumberController,
                  onVehicleTypeChanged: onVehicleTypeChanged,
                  onZoneChanged: onZoneChanged,
                  onPickImage: onPickImage,
                ),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            Row(
              children: [
                if (state.currentStep > 0) ...[
                  Expanded(
                    child: AppButton.outlined(
                      text: locale.driver_profile_step_back,
                      onPressed: state.isLoading ? null : onBack,
                      height: 54,
                      borderRadius: 18,
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                ],
                Expanded(
                  child: AppButton.filled(
                    text: state.currentStep == titles.length - 1
                        ? locale.driver_profile_submit_information
                        : locale.driver_profile_step_next,
                    onPressed: state.isLoading ? null : onNext,
                    height: 54,
                    borderRadius: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
