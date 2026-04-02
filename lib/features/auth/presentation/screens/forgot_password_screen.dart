import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/validators.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_experience_shell.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_text_field.dart';

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

  String _copy(BuildContext context, String ar, String en) {
    return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
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
    final color = context.colorScheme;

    return AuthExperienceShell(
      heroBadge: _copy(context, 'استرجاع سريع', 'Quick recovery'),
      heroTitle: locale.forget_password_title,
      heroSubtitle: _copy(
        context,
        'أدخل البريد أو رقم الجوال المرتبط بالحساب وسنوجّهك مباشرة إلى خطوة تعيين كلمة المرور الجديدة.',
        'Enter the email or phone linked to the account and continue to the new password step.',
      ),
      sectionBadge: _copy(context, 'استعادة الوصول', 'Recover access'),
      sectionTitle: locale.forget_password_title,
      sectionDescription: locale.forget_password_description,
      sectionIcon: Icons.lock_reset_rounded,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthTextField(
              controller: _identifierController,
              label: locale.label_email_or_phone,
              hintText: locale.hint_email_or_phone,
              validator: (value) =>
                  Validations.validateEmailOrPhone(context, value),
              enabled: !_isSubmitting,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(
                Icons.mark_email_read_outlined,
                color: color.onSurface.withValues(alpha: 0.6),
              ),
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
