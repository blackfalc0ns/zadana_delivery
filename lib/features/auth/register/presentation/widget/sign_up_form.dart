import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/validators.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/auth/auth_password_field.dart';
import 'package:zadana_delivery/core/widgets/auth/auth_text_field.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    required this.isSubmitting,
    required this.onSubmit,
    this.errorMessage,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isSubmitting;
  final String? errorMessage;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    Widget prefix(IconData icon) {
      return Icon(icon, color: color.onSurface.withValues(alpha: 0.6));
    }

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthTextField(
            controller: fullNameController,
            label: locale.label_full_name,
            hintText: locale.hint_full_name,
            validator: (value) => Validations.validateName(context, value),
            textInputAction: TextInputAction.next,
            enabled: !isSubmitting,
            prefixIcon: prefix(Icons.person_outline_rounded),
          ),
          const SizedBox(height: Spacing.md),
          AuthTextField(
            controller: emailController,
            label: locale.label_email,
            hintText: locale.hint_email,
            validator: (value) => Validations.validateEmail(context, value),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !isSubmitting,
            prefixIcon: prefix(Icons.email_outlined),
          ),
          const SizedBox(height: Spacing.md),
          AuthTextField(
            controller: phoneController,
            label: locale.label_phone,
            hintText: locale.hint_phone,
            validator: (value) =>
                Validations.validatePhoneNumber(context, value),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            enabled: !isSubmitting,
            prefixIcon: prefix(Icons.call_outlined),
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
          if ((errorMessage ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: Spacing.base),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.error.withValues(alpha: 0.12)),
              ),
              child: Text(
                errorMessage!,
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  color: color.error,
                ),
              ),
            ),
          ],
          const SizedBox(height: Spacing.lg),
          AppButton.filled(
            text: locale.auth_continue,
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
