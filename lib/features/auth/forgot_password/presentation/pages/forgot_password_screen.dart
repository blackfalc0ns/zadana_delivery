import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_presentation.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/validators.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/auth/auth_experience_shell.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/core/widgets/turnstile_challenge_widget.dart';
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

  /// Cloudflare Turnstile token. Empty string means CAPTCHA is disabled.
  String? _turnstileToken;

  // TODO: Load this from remote config or environment variable.
  // Empty string disables CAPTCHA (for staging/dev).
  static const String _turnstileSiteKey = '';

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

    // If CAPTCHA is enabled and token not yet obtained, wait.
    if (_turnstileSiteKey.isNotEmpty && (_turnstileToken ?? '').isEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: 'فضلاً أكمل التحقق أولاً',
      );
      return;
    }

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
          botChallengeToken: _turnstileToken,
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
        listenWhen: (previous, current) =>
            previous.isSuccess != current.isSuccess ||
            previous.response != current.response ||
            previous.failure != current.failure,
        listener: (context, state) {
          if (state.isSuccess && state.response != null) {
            CustomSnackbar.showSuccess(
              context: context,
              message: state.response!.message,
            );
            context.pushNamed(
              AppRoutes.verifyResetOtp,
              arguments: _identifierController.text.trim(),
              rootNavigator: true,
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
                      const SizedBox(height: 16),
                      TurnstileChallengeWidget(
                        siteKey: _turnstileSiteKey,
                        onTokenObtained: (token) {
                          setState(() => _turnstileToken = token);
                        },
                      ),
                      const SizedBox(height: 20),
                      AppButton.filled(
                        text: locale.btn_send_verification_code,
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
