import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/validators.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_footer_prompt.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_password_field.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_text_field.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    super.key,
    required this.fullNameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    Widget icon(IconData data) => Icon(
          data,
          color: color.onSurface.withValues(alpha: 0.6),
        );

    return Column(
      children: [
        AuthTextField(
          controller: fullNameController,
          label: locale.label_full_name,
          hintText: locale.hint_full_name,
          validator: (value) => Validations.validateName(context, value),
          textInputAction: TextInputAction.next,
          enabled: !isSubmitting,
          prefixIcon: icon(Icons.person_outline_rounded),
        ),
        const SizedBox(height: 8),
        AuthTextField(
          controller: emailController,
          label: locale.label_email,
          hintText: locale.hint_email,
          validator: (value) => Validations.validateEmail(context, value),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          enabled: !isSubmitting,
          prefixIcon: icon(Icons.email_outlined),
        ),
        const SizedBox(height: 8),
        AuthTextField(
          controller: phoneController,
          label: locale.label_phone,
          hintText: locale.hint_phone,
          validator: (value) => Validations.validatePhoneNumber(context, value),
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          enabled: !isSubmitting,
          prefixIcon: icon(Icons.call_outlined),
        ),
        const SizedBox(height: 8),
        AuthPasswordField(
          controller: passwordController,
          label: locale.label_password,
          hintText: locale.hint_password,
          validator: (value) => Validations.validatePassword(context, value),
          enabled: !isSubmitting,
          onFieldSubmitted: (_) => onSubmit(),
        ),
        const SizedBox(height: 24),
        AppButton.filled(
          text: locale.auth_continue,
          isLoading: isSubmitting,
          onPressed: isSubmitting ? null : onSubmit,
        ),
        const SizedBox(height: 4),
        AuthFooterPrompt(
          label: locale.footer_have_account,
          actionText: locale.footer_action_login,
          onPressed: context.pop,
        ),
      ],
    );
  }
}

