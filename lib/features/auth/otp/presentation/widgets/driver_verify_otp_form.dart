import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/validators.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';

class DriverVerifyOtpForm extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            locale.auth_verify_otp_identifier_label,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size11,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.base,
              vertical: Spacing.md,
            ),
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(Spacing.inputRadius),
              border: Border.all(color: color.outline.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    identifier,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size13,
                      color: color.onSurface,
                    ),
                  ),
                ),
                Icon(
                  Icons.email_outlined,
                  color: color.onSurface.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.md),
          Text(
            locale.label_verification_code,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size11,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          TextFormField(
            controller: otpController,
            enabled: !isSubmitting,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            textAlign: TextAlign.center,
            maxLength: 4,
            validator: (value) => Validations.validOtp(context, value),
            onFieldSubmitted: (_) => onSubmit(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size20,
              color: color.onSurface,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: locale.auth_verify_otp_code_hint,
              hintStyle: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size13,
                color: color.onSurface.withValues(alpha: 0.5),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsetsDirectional.only(start: 10, end: 6),
                child: Icon(
                  Icons.pin_outlined,
                  color: color.onSurface.withValues(alpha: 0.6),
                ),
              ),
              filled: true,
              fillColor: color.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: Spacing.base,
                vertical: Spacing.md,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Spacing.inputRadius),
                borderSide: BorderSide(
                  color: color.outline.withValues(alpha: 0.2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Spacing.inputRadius),
                borderSide: BorderSide(
                  color: color.outline.withValues(alpha: 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Spacing.inputRadius),
                borderSide: BorderSide(color: color.primary, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Spacing.inputRadius),
                borderSide: BorderSide(color: color.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Spacing.inputRadius),
                borderSide: BorderSide(color: color.error, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            locale.auth_verify_otp_code_helper,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size11,
              color: color.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          AppButton.filled(
            text: locale.otp_verify_button,
            onPressed: isSubmitting ? null : onSubmit,
            height: 52,
            borderRadius: 18,
          ),
          const SizedBox(height: Spacing.sm),
          Align(
            alignment: AlignmentDirectional.center,
            child: TextButton(
              onPressed: isSubmitting || isResending ? null : onResend,
              child: Text(
                isResending
                    ? locale.auth_verify_otp_resending
                    : locale.auth_verify_otp_resend_action,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size13,
                  color: color.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
