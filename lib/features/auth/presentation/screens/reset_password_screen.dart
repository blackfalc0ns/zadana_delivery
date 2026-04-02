import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/validators.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_experience_shell.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_password_field.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.identifier});

  final String identifier;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;

    setState(() => _isSubmitting = false);
    context.pushNamedAndRemoveUntil(
      AppRoutes.login,
      arguments: widget.identifier,
      predicate: (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return AuthExperienceShell(
      heroBadge: locale.auth_reset_hero_badge,
      heroTitle: locale.reset_password_title,
      heroSubtitle: locale.auth_reset_hero_subtitle,
      sectionBadge: locale.auth_reset_section_badge,
      sectionTitle: locale.reset_password_title,
      sectionDescription:
          '${locale.reset_password_description_prefix} ${widget.identifier}',
      sectionIcon: Icons.password_rounded,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthTextField(
              controller: _otpController,
              label: locale.label_verification_code,
              hintText: locale.hint_verification_code,
              validator: (value) => Validations.validOtp(context, value),
              enabled: !_isSubmitting,
              keyboardType: TextInputType.number,
              prefixIcon: Icon(
                Icons.pin_outlined,
                color: color.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 12),
            AuthPasswordField(
              controller: _passwordController,
              label: locale.label_password,
              hintText: locale.hint_password,
              validator: (value) =>
                  Validations.validatePassword(context, value),
              enabled: !_isSubmitting,
            ),
            const SizedBox(height: 12),
            AuthPasswordField(
              controller: _confirmPasswordController,
              label: locale.auth_confirm_password_label,
              hintText: locale.auth_confirm_password_hint,
              validator: (value) => Validations.validateConfirmPassword(
                context,
                _passwordController.text,
                value,
              ),
              enabled: !_isSubmitting,
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 20),
            AppButton.filled(
              text: locale.reset_password_title,
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
