import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/validators.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_footer_prompt.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_password_field.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/email_phone_input_field.dart';

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
          Text(
            locale.label_email_or_phone,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size13,
              color: color.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          EmailPhoneInputField(
            controller: emailOrPhoneController,
            validator: (value) =>
                Validations.validateEmailOrPhone(context, value),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 10),
          AuthPasswordField(
            controller: passwordController,
            label: locale.label_password,
            hintText: locale.hint_password,
            validator: (value) =>
                Validations.validatePassword(context, value),
            enabled: !isSubmitting,
            onFieldSubmitted: (_) => onSubmit(),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: isSubmitting ? null : onForgotPassword,
              style: TextButton.styleFrom(
                foregroundColor: color.primary,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
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
          const SizedBox(height: 8),
          AppButton.filled(height: 48,
            text: locale.toggle_login,
            isLoading: isSubmitting,
            onPressed: isSubmitting ? null : onSubmit,
          ),
          const SizedBox(height: 6),
          AuthFooterPrompt(
            label: locale.footer_no_account,
            actionText: locale.footer_action_signup,
            onPressed: () => context.pushNamed(AppRoutes.signUp),
          ),
        ],
      ),
    );
  }
}
