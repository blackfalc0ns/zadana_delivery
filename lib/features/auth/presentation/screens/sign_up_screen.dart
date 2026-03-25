import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_screen_layout.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/sign_up_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    context.pushReplacementNamed(AppRoutes.driverProfileCompletion);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AuthScreenLayout(
        caption: locale.auth_signup_caption,
        title: locale.btn_signup,
        subtitle: locale.auth_subtitle_signup,
        description: locale.auth_signup_description,
        child: SignUpForm(
          fullNameController: _fullNameController,
          phoneController: _phoneController,
          emailController: _emailController,
          passwordController: _passwordController,
          isSubmitting: _isSubmitting,
          onSubmit: _submit,
        ),
      ),
    );
  }
}
