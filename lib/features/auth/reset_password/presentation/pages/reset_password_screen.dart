import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_presentation.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/validators.dart';
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
  const ResetPasswordScreen({super.key, required this.identifier});

  final String identifier;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  static const int _resendCooldown = 60;

  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late final ResetPasswordViewModel _cubit;

  late final List<TextEditingController> _otpDigitControllers;
  late final List<FocusNode> _otpFocusNodes;
  Timer? _resendTimer;
  int _resendCountdown = 0;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ResetPasswordViewModel>();

    _otpDigitControllers = List.generate(4, (_) => TextEditingController());
    _otpFocusNodes = List.generate(4, (_) => FocusNode());

    for (final controller in _otpDigitControllers) {
      controller.addListener(_syncOtpValue);
    }

    _otpController.addListener(_cubit.clearError);
    _passwordController.addListener(_cubit.clearError);
    _confirmPasswordController.addListener(_cubit.clearError);
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    for (final controller in _otpDigitControllers) {
      controller.dispose();
    }
    for (final node in _otpFocusNodes) {
      node.dispose();
    }
    _cubit.close();
    super.dispose();
  }

  void _syncOtpValue() {
    final combined = _otpDigitControllers.map((c) => c.text).join();
    if (_otpController.text != combined) {
      _otpController.text = combined;
    }
  }

  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < 3) {
      _otpFocusNodes[index + 1].requestFocus();
    }
  }

  void _onKeyPress(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _otpDigitControllers[index].text.isEmpty &&
        index > 0) {
      _otpDigitControllers[index - 1].clear();
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Validate OTP is complete (4 digits)
    final otpCode = _otpController.text.trim();
    if (otpCode.length != 4) {
      CustomSnackbar.showError(
        context: context,
        message: context.localization.verification_code_invalid,
      );
      return;
    }

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

  void _handleResend() {
    if (_resendCountdown > 0) return;
    _cubit.doIntent(ResetPasswordResendCodeEvent(widget.identifier));
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() => _resendCountdown = _resendCooldown);
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown <= 1) {
        timer.cancel();
        if (mounted) setState(() => _resendCountdown = 0);
      } else {
        if (mounted) setState(() => _resendCountdown--);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<ResetPasswordViewModel, ResetPasswordState>(
        listenWhen: (previous, current) =>
            previous.isSuccess != current.isSuccess ||
            previous.response != current.response ||
            previous.failure != current.failure ||
            previous.resendMessage != current.resendMessage ||
            previous.resendFailure != current.resendFailure,
        listener: (context, state) {
          if (state.isSuccess && state.response != null) {
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

          final resendMessage = state.resendMessage?.trim() ?? '';
          if (resendMessage.isNotEmpty) {
            CustomSnackbar.showSuccess(
              context: context,
              message: resendMessage,
            );
            _cubit.clearResendFeedback();
            return;
          }

          final resendException = state.resendFailure?.asException;
          if (!state.isResending &&
              resendException != null &&
              resendException.errorType.showSnackBar) {
            CustomSnackbar.showError(
              context: context,
              message: ErrorMessagePresenter.snackBarMessage(
                context,
                resendException,
              ),
            );
            _cubit.clearResendFeedback();
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
                      // OTP label
                      Text(
                        locale.label_verification_code,
                        textAlign: TextAlign.center,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size14,
                          color: color.onSurface,
                        ),
                      ),
                      const SizedBox(height: Spacing.md),

                      // 4 OTP digit fields
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (index) {
                            return Container(
                              width: 60,
                              height: 60,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: KeyboardListener(
                                focusNode: FocusNode(),
                                onKeyEvent: (event) =>
                                    _onKeyPress(index, event),
                                child: TextFormField(
                                  controller: _otpDigitControllers[index],
                                  focusNode: _otpFocusNodes[index],
                                  enabled: !state.isLoading,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (value) =>
                                      _onDigitChanged(index, value),
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.cairo,
                                    fontSize: FontSize.size24,
                                    color: color.onSurface,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    filled: true,
                                    fillColor: color.surface,
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: color.outline
                                            .withValues(alpha: 0.3),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: color.outline
                                            .withValues(alpha: 0.3),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: color.primary,
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(14),
                                      borderSide:
                                          BorderSide(color: color.error),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: Spacing.sm),

                      // Resend button with countdown
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextButton(
                          onPressed: (_resendCountdown > 0 ||
                                  state.isLoading ||
                                  state.isResending)
                              ? null
                              : _handleResend,
                          child: Text(
                            state.isResending
                                ? locale.auth_verify_otp_resending
                                : _resendCountdown > 0
                                    ? '${locale.auth_verify_otp_resend_action} (${_resendCountdown}s)'
                                    : locale.auth_verify_otp_resend_action,
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size13,
                              color:
                                  (_resendCountdown > 0 || state.isResending)
                                      ? color.onSurface
                                          .withValues(alpha: 0.4)
                                      : color.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: Spacing.md),

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
                        validator: (value) =>
                            Validations.validateConfirmPassword(
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
