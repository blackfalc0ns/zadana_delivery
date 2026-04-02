import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/validators.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_password_field.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_text_field.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailOrPhoneController,
    required this.passwordController,
    required this.isSubmitting,
    required this.onSubmit,
    required this.onForgotPassword,
    this.errorMessage,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailOrPhoneController;
  final TextEditingController passwordController;
  final bool isSubmitting;
  final String? errorMessage;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthTextField(
            controller: emailOrPhoneController,
            label: locale.label_email_or_phone,
            hintText: locale.hint_email_or_phone,
            validator: (value) =>
                Validations.validateEmailOrPhone(context, value),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !isSubmitting,
            prefixIcon: Icon(
              Icons.alternate_email_rounded,
              color: color.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: Spacing.md),
          AuthPasswordField(
            controller: passwordController,
            label: locale.label_password,
            hintText: locale.hint_password,
            validator: (value) => Validations.validatePassword(context, value),
            enabled: !isSubmitting,
            onFieldSubmitted: (_) => onSubmit(),
          ),
          const SizedBox(height: Spacing.xs),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: isSubmitting ? null : onForgotPassword,
              child: Text(
                locale.btn_forgot_password,
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size12,
                  color: color.primary,
                ),
              ),
            ),
          ),
          if ((errorMessage ?? '').trim().isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.error.withValues(alpha: 0.12)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: color.error,
                    size: 20,
                  ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size12,
                        color: color.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.base),
          ],
          AppButton.filled(
            text: context.localization.toggle_login,
            isLoading: isSubmitting,
            onPressed: isSubmitting ? null : onSubmit,
            height: 52,
            borderRadius: 18,
          ),
          const SizedBox(height: Spacing.base),
          // Container(
          //   padding: const EdgeInsets.all(14),
          //   decoration: BoxDecoration(
          //     color: AppColors.primary.withValues(alpha: 0.05),
          //     borderRadius: BorderRadius.circular(18),
          //   ),
          //   child: Row(
          //     children: [
          //       Icon(
          //         Icons.security_rounded,
          //         color: AppColors.primary,
          //         size: 20,
          //       ),
          //       const SizedBox(width: Spacing.sm),
          //       Expanded(
          //         child: Text(
          //           Localizations.localeOf(context).languageCode == 'ar'
          //               ? 'يتم حفظ جلستك بأمان على هذا الجهاز لتسهيل الدخول لاحقًا.'
          //               : 'Your session is securely stored on this device for a faster next sign in.',
          //           style: getRegularStyle(
          //             fontFamily: FontConstant.cairo,
          //             fontSize: FontSize.size12,
          //             color: AppColors.textSecondary,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
