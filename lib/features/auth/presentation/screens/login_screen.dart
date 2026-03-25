import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_screen_layout.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailOrPhoneController.addListener(_clearError);
    _passwordController.addListener(_clearError);
  }

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearError() {
    if (_errorMessage != null) setState(() => _errorMessage = null);
  }

  Future<void> _submit() async {
    final locale = context.localization;
    FocusScope.of(context).unfocus();
    setState(() => _errorMessage = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    final isValid = _emailOrPhoneController.text.trim().toLowerCase() == 'driver@zadana.com' &&
        _passwordController.text == 'Driver@123';

    setState(() {
      _isSubmitting = false;
      _errorMessage = isValid ? null : locale.auth_login_error;
    });

    if (_errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(locale.login_success)),
      );
    }
  }

  void _showForgotPasswordMessage() {
    final locale = context.localization;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(locale.auth_forgot_password_pending)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AuthScreenLayout(
        caption: locale.auth_driver_account_caption,
        title: locale.auth_title,
        subtitle: locale.auth_subtitle_login,
        description: locale.auth_login_description,
        child: LoginForm(
          formKey: _formKey,
          emailOrPhoneController: _emailOrPhoneController,
          passwordController: _passwordController,
          isSubmitting: _isSubmitting,
          onSubmit: _submit,
          onForgotPassword: _showForgotPasswordMessage,
        ),
      ),
    );
  }
}
