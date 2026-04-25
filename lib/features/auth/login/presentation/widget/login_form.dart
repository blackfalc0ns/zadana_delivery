import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/validators.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/auth/auth_password_field.dart';
import 'package:zadana_delivery/core/widgets/auth/auth_text_field.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailOrPhoneController,
    required this.passwordController,
    required this.isSubmitting,
    required this.onSubmit,
    required this.onForgotPassword,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailOrPhoneController;
  final TextEditingController passwordController;
  final bool isSubmitting;
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
              Icons.email_outlined,
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
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  color: color.primary,
                ),
              ),
            ),
          ),
          AppButton.filled(
            text: context.localization.toggle_login,
            isLoading: isSubmitting,
            onPressed: isSubmitting ? null : onSubmit,
            height: 52,
            borderRadius: 18,
          ),
          const SizedBox(height: Spacing.base),
        ],
      ),
    );
  }
}
