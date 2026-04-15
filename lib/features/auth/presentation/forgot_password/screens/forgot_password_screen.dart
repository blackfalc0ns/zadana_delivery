import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/validators.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_experience_shell.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/email_phone_input_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;

    setState(() => _isSubmitting = false);
    context.pushNamed(
      AppRoutes.resetPassword,
      arguments: _identifierController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return AuthExperienceShell(
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
            const SizedBox(height: 20),
            AppButton.filled(
              text: locale.btn_send_verification_code,
              isLoading: _isSubmitting,
              onPressed: _isSubmitting ? null : _submit,
              height: 52,
              borderRadius: 18,
            ),
          ],
        ),
      ),
    );
  }
}
