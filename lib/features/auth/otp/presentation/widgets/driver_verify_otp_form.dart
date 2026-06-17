import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';

class DriverVerifyOtpForm extends StatefulWidget {
  const DriverVerifyOtpForm({
    super.key,
    required this.formKey,
    required this.identifier,
    required this.otpController,
    required this.isSubmitting,
    required this.isResending,
    required this.onSubmit,
    required this.onResend,
  });

  final GlobalKey<FormState> formKey;
  final String identifier;
  final TextEditingController otpController;
  final bool isSubmitting;
  final bool isResending;
  final VoidCallback onSubmit;
  final VoidCallback onResend;

  @override
  State<DriverVerifyOtpForm> createState() => _DriverVerifyOtpFormState();
}

class _DriverVerifyOtpFormState extends State<DriverVerifyOtpForm> {
  static const int _resendCooldown = 60;

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  Timer? _resendTimer;
  int _resendCountdown = 0;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (_) => TextEditingController());
    _focusNodes = List.generate(4, (_) => FocusNode());

    // Sync individual controllers to the main otpController
    for (final controller in _controllers) {
      controller.addListener(_syncOtpValue);
    }
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _syncOtpValue() {
    final combined = _controllers.map((c) => c.text).join();
    if (widget.otpController.text != combined) {
      widget.otpController.text = combined;
    }
  }

  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    // Auto-submit when all 4 digits are entered
    if (index == 3 && value.isNotEmpty) {
      final allFilled = _controllers.every((c) => c.text.isNotEmpty);
      if (allFilled) {
        FocusScope.of(context).unfocus();
        widget.onSubmit();
      }
    }
  }

  void _onKeyPress(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _handleResend() {
    if (_resendCountdown > 0 || widget.isResending) return;
    widget.onResend();
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

    return Form(
      key: widget.formKey,
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

          // 4 OTP fields
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: KeyboardListener(
                    focusNode: FocusNode(),
                    onKeyEvent: (event) => _onKeyPress(index, event),
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      enabled: !widget.isSubmitting,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) => _onDigitChanged(index, value),
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
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: color.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: color.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: color.primary,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: color.error),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: Spacing.sm),

          // // Helper text
          // Text(
          //   locale.auth_verify_otp_code_helper,
          //   textAlign: TextAlign.center,
          //   style: getRegularStyle(
          //     fontFamily: FontConstant.cairo,
          //     fontSize: FontSize.size11,
          //     color: color.onSurface.withValues(alpha: 0.6),
          //   ),
          // ),
          // const SizedBox(height: Spacing.xl),

          // Submit button
          AppButton.filled(
            text: locale.otp_verify_button,
            onPressed: widget.isSubmitting ? null : widget.onSubmit,
            height: 52,
            borderRadius: 18,
          ),
        

          // Resend button with countdown
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: (_resendCountdown > 0 ||
                      widget.isSubmitting ||
                      widget.isResending)
                  ? null
                  : _handleResend,
              child: Text(
                widget.isResending
                    ? locale.auth_verify_otp_resending
                    : _resendCountdown > 0
                        ? '${locale.auth_verify_otp_resend_action} (${_resendCountdown}s)'
                        : locale.auth_verify_otp_resend_action,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size13,
                  color: (_resendCountdown > 0 || widget.isResending)
                      ? color.onSurface.withValues(alpha: 0.4)
                      : color.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
