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
import 'package:zadana_delivery/core/widgets/auth/auth_password_field.dart';
import 'package:zadana_delivery/core/widgets/auth/auth_text_field.dart';
import 'package:zadana_delivery/core/widgets/custom_snackbar.dart';
import 'package:zadana_delivery/features/auth/reset_password/domain/entities/reset_password_request_entity.dart';
import 'package:zadana_delivery/features/auth/reset_password/presentation/manager/reset_password_event.dart';
import 'package:zadana_delivery/features/auth/reset_password/presentation/manager/reset_password_state.dart';
import 'package:zadana_delivery/features/auth/reset_password/presentation/manager/reset_password_view_model.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.identifier});

  final String identifier;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final ResetPasswordViewModel _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ResetPasswordViewModel>();
    _otpController.addListener(_cubit.clearError);
    _passwordController.addListener(_cubit.clearError);
    _confirmPasswordController.addListener(_cubit.clearError);
  }

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cubit.close();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await _submitWithCurrentValues();
  }

  Future<void> _retrySubmit() async {
    final otpCode = _otpController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    if (otpCode.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _cubit.clearError();
      return;
    }

    await _submitWithCurrentValues();
  }

  Future<void> _submitWithCurrentValues() async {
    FocusScope.of(context).unfocus();
    await _cubit.doIntent(
      ResetPasswordSubmitEvent(
        ResetPasswordRequestEntity(
          identifier: widget.identifier,
          otpCode: _otpController.text.trim(),
          newPassword: _passwordController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<ResetPasswordViewModel, ResetPasswordState>(
        listener: (context, state) {
          if (state.isSuccess && state.response != null) {
            CustomSnackbar.showSuccess(
              context: context,
              message: state.response!.message,
            );
            context.pushNamedAndRemoveUntil(
              AppRoutes.login,
              arguments: widget.identifier,
              predicate: (route) => false,
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
            heroBadge: locale.auth_reset_hero_badge,
            heroTitle: locale.reset_password_title,
            heroSubtitle: locale.auth_reset_hero_subtitle,
            sectionBadge: locale.auth_reset_section_badge,
            showBackButton: true,
            sectionTitle: locale.reset_password_title,
            sectionDescription:
                '${locale.reset_password_description_prefix} ${widget.identifier}',
            sectionIcon: Icons.password_rounded,
            body: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthTextField(
                    controller: _otpController,
                    label: locale.label_verification_code,
                    hintText: locale.hint_verification_code,
                    validator: (value) => Validations.validOtp(context, value),
                    enabled: !state.isLoading,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icon(
                      Icons.pin_outlined,
                      color: color.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AuthPasswordField(
                    controller: _passwordController,
                    label: locale.label_password,
                    hintText: locale.hint_password,
                    validator: (value) =>
                        Validations.validatePassword(context, value),
                    enabled: !state.isLoading,
                  ),
                  const SizedBox(height: 12),
                  AuthPasswordField(
                    controller: _confirmPasswordController,
                    label: locale.auth_confirm_password_label,
                    hintText: locale.auth_confirm_password_hint,
                    validator: (value) => Validations.validateConfirmPassword(
                      context,
                      _passwordController.text,
                      value,
                    ),
                    enabled: !state.isLoading,
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 20),
                  AppButton.filled(
                    text: locale.reset_password_title,
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
