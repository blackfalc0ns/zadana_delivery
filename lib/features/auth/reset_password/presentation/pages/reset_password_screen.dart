import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_presentation.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/validators.dart';
import 'package:zadana_delivery/core/services/driver_realtime_service.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/auth/auth_experience_shell.dart';
import 'package:zadana_delivery/core/widgets/auth/auth_password_field.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/auth/reset_password/domain/entities/reset_password_request_entity.dart';
import 'package:zadana_delivery/features/auth/reset_password/presentation/manager/reset_password_event.dart';
import 'package:zadana_delivery/features/auth/reset_password/presentation/manager/reset_password_state.dart';
import 'package:zadana_delivery/features/auth/reset_password/presentation/manager/reset_password_view_model.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.identifier,
    required this.resetToken,
  });

  final String identifier;
  final String resetToken;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final ResetPasswordViewModel _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ResetPasswordViewModel>();
    _passwordController.addListener(_cubit.clearError);
    _confirmPasswordController.addListener(_cubit.clearError);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cubit.close();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    await _cubit.doIntent(
      ResetPasswordSubmitEvent(
        ResetPasswordRequestEntity(
          identifier: widget.identifier,
          resetToken: widget.resetToken,
          newPassword: _passwordController.text,
        ),
      ),
    );
  }

  Future<void> _retrySubmit() async {
    if (_passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _cubit.clearError();
      return;
    }
    await _submit();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<ResetPasswordViewModel, ResetPasswordState>(
        listenWhen: (previous, current) =>
            previous.isSuccess != current.isSuccess ||
            previous.response != current.response ||
            previous.failure != current.failure,
        listener: (context, state) {
          if (state.isSuccess && state.response != null) {
            // Disconnect realtime services before navigating to prevent
            // stale token reconnection attempts that cause 401 errors.
            getIt<DriverRealtimeService>().disconnect();

            CustomSnackbar.showSuccess(
              context: context,
              message: state.response!.message,
            );
            context.pushNamedAndRemoveUntil(
              AppRoutes.login,
              arguments: widget.identifier,
              rootNavigator: true,
              predicate: (route) => false,
            );
            return;
          }

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
        },
        builder: (context, state) {
          final exception = state.failure?.asException;
          if (!state.isLoading &&
              exception != null &&
              exception.errorType.showFullScreen) {
            return Scaffold(
              backgroundColor: context.colorScheme.surface,
              body: SafeArea(
                child: ApiErrorWidget(
                  exception: exception,
                  onRetry: _retrySubmit,
                  onGoBack: _cubit.clearError,
                ),
              ),
            );
          }

          return Stack(
            children: [
              AuthExperienceShell(
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
                      AuthPasswordField(
                        controller: _passwordController,
                        label: locale.label_password,
                        hintText: locale.hint_password,
                        validator: (value) =>
                            Validations.validatePassword(context, value),
                        enabled: !state.isLoading,
                      ),
                      const SizedBox(height: Spacing.md),
                      AuthPasswordField(
                        controller: _confirmPasswordController,
                        label: locale.auth_confirm_password_label,
                        hintText: locale.auth_confirm_password_hint,
                        validator: (value) =>
                            Validations.validateConfirmPassword(
                          context,
                          _passwordController.text,
                          value,
                        ),
                        enabled: !state.isLoading,
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: Spacing.xl),
                      AppButton.filled(
                        text: locale.reset_password_title,
                        onPressed: state.isLoading ? null : _submit,
                        height: 52,
                        borderRadius: 18,
                      ),
                    ],
                  ),
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
          );
        },
      ),
    );
  }
}
