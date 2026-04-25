import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/validators.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/auth/auth_experience_shell.dart';
import 'package:zadana_delivery/core/widgets/custom_snackbar.dart';
import 'package:zadana_delivery/features/auth/forgot_password/domain/entities/forgot_password_request_entity.dart';
import 'package:zadana_delivery/features/auth/forgot_password/presentation/manager/forgot_password_event.dart';
import 'package:zadana_delivery/features/auth/forgot_password/presentation/manager/forgot_password_state.dart';
import 'package:zadana_delivery/features/auth/forgot_password/presentation/manager/forgot_password_view_model.dart';
import 'package:zadana_delivery/features/auth/forgot_password/presentation/widgets/email_phone_input_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  late final ForgotPasswordViewModel _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ForgotPasswordViewModel>();
    _identifierController.addListener(_cubit.clearError);
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _cubit.close();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await _submitWithCurrentValue();
  }

  Future<void> _retrySubmit() async {
    if (_identifierController.text.trim().isEmpty) {
      _cubit.clearError();
      return;
    }

    await _submitWithCurrentValue();
  }

  Future<void> _submitWithCurrentValue() async {
    FocusScope.of(context).unfocus();
    await _cubit.doIntent(
      ForgotPasswordSubmitEvent(
        ForgotPasswordRequestEntity(
          identifier: _identifierController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<ForgotPasswordViewModel, ForgotPasswordState>(
        listener: (context, state) {
          if (state.isSuccess && state.response != null) {
            CustomSnackbar.showSuccess(
              context: context,
              message: state.response!.message,
            );
            context.pushNamed(
              AppRoutes.resetPassword,
              arguments: _identifierController.text.trim(),
            );
            return;
          }
        },
        builder: (context, state) {
          if (!state.isLoading && state.failure != null) {
            return Scaffold(
              backgroundColor: context.colorScheme.surface,
              body: SafeArea(
                child: ApiErrorWidget.fromFailure(
                  state.failure!,
                  onRetry: _retrySubmit,
                  onGoBack: _cubit.clearError,
                ),
              ),
            );
          }

          return AuthExperienceShell(
            heroBadge: locale.auth_forgot_hero_badge,
            heroTitle: locale.forget_password_title,
            heroSubtitle: locale.auth_forgot_hero_subtitle,
            sectionBadge: locale.auth_forgot_section_badge,
            showBackButton: true,
            sectionTitle: locale.forget_password_title,
            sectionDescription: locale.forget_password_description,
            sectionIcon: Icons.lock_reset_rounded,
            body: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  EmailPhoneInputField(
                    controller: _identifierController,
                    validator: (value) =>
                        Validations.validateEmailOrPhone(context, value),
                  ),
                  const SizedBox(height: 20),
                  AppButton.filled(
                    text: locale.btn_send_verification_code,
                    isLoading: state.isLoading,
                    onPressed: state.isLoading ? null : _submit,
                    height: 52,
                    borderRadius: 18,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
