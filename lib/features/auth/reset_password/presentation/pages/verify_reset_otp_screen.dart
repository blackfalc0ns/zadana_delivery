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
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/auth/auth_experience_shell.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/auth/reset_password/domain/entities/verify_reset_otp_request_entity.dart';
import 'package:zadana_delivery/features/auth/reset_password/presentation/manager/verify_reset_otp_event.dart';
import 'package:zadana_delivery/features/auth/reset_password/presentation/manager/verify_reset_otp_state.dart';
import 'package:zadana_delivery/features/auth/reset_password/presentation/manager/verify_reset_otp_view_model.dart';

class VerifyResetOtpScreen extends StatefulWidget {
  const VerifyResetOtpScreen({super.key, required this.identifier});

  final String identifier;

  @override
  State<VerifyResetOtpScreen> createState() => _VerifyResetOtpScreenState();
}

class _VerifyResetOtpScreenState extends State<VerifyResetOtpScreen> {
  static const int _resendCooldown = 60;

  final _otpController = TextEditingController();
  late final VerifyResetOtpViewModel _cubit;

  late final List<TextEditingController> _otpDigitControllers;
  late final List<FocusNode> _otpFocusNodes;
  Timer? _resendTimer;
  int _resendCountdown = 0;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<VerifyResetOtpViewModel>();

    _otpDigitControllers = List.generate(4, (_) => TextEditingController());
    _otpFocusNodes = List.generate(4, (_) => FocusNode());

    for (final controller in _otpDigitControllers) {
      controller.addListener(_syncOtpValue);
    }

    _otpController.addListener(_cubit.clearError);
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _otpController.dispose();
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
    final otpCode = _otpController.text.trim();
    if (otpCode.length != 4) {
      CustomSnackbar.showError(
        context: context,
        message: context.localization.verification_code_invalid,
      );
      return;
    }

    FocusScope.of(context).unfocus();
    await _cubit.doIntent(
      VerifyResetOtpSubmitEvent(
        VerifyResetOtpRequestEntity(
          identifier: widget.identifier,
          otpCode: otpCode,
        ),
      ),
    );
  }

  Future<void> _retrySubmit() async {
    if (_otpController.text.trim().length != 4) {
      _cubit.clearError();
      return;
    }
    await _submit();
  }

  Future<void> _handleResend() async {
    if (_resendCountdown > 0) return;
    _startResendTimer();
    await _cubit.doIntent(VerifyResetOtpResendEvent(widget.identifier));
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
      child: BlocConsumer<VerifyResetOtpViewModel, VerifyResetOtpState>(
        listenWhen: (previous, current) =>
            previous.isSuccess != current.isSuccess ||
            previous.response != current.response ||
            previous.failure != current.failure ||
            previous.resendMessage != current.resendMessage ||
            previous.resendFailure != current.resendFailure,
        listener: (context, state) {
          // On success, navigate to new password screen with resetToken
          if (state.isSuccess && state.response != null) {
            context.pushReplacementNamed(
              AppRoutes.resetPassword,
              rootNavigator: true,
              arguments: ResetPasswordArgs(
                identifier: widget.identifier,
                resetToken: state.response!.resetToken,
              ),
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
          if (!state.isResending && resendException != null) {
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
                heroBadge: locale.auth_verify_otp_hero_badge,
                heroTitle: locale.auth_verify_otp_hero_title,
                heroSubtitle: locale.auth_verify_otp_hero_subtitle,
                sectionBadge: locale.auth_verify_otp_section_badge,
                showBackButton: true,
                sectionTitle: locale.auth_verify_otp_section_title,
                sectionDescription:
                    '${locale.auth_verify_otp_section_description} ${widget.identifier}',
                sectionIcon: Icons.verified_user_outlined,
                body: Column(
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
                    const SizedBox(height: Spacing.lg),

                    AppButton.filled(
                      text: locale.otp_verify_button,
                      onPressed: state.isLoading ? null : _submit,
                      height: 52,
                      borderRadius: 18,
                    ),
                  ],
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

/// Arguments passed from [VerifyResetOtpScreen] to [ResetPasswordScreen].
class ResetPasswordArgs {
  const ResetPasswordArgs({
    required this.identifier,
    required this.resetToken,
  });

  final String identifier;
  final String resetToken;
}
