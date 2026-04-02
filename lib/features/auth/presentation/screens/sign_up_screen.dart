import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_experience_shell.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/sign_up_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    for (final controller in [
      _fullNameController,
      _phoneController,
      _emailController,
      _passwordController,
    ]) {
      controller.addListener(_clearError);
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearError() {
    if (_errorMessage != null) {
      setState(() => _errorMessage = null);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _errorMessage = null;
      _isSubmitting = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;

    setState(() => _isSubmitting = false);
    context.pushReplacementNamed(
      AppRoutes.login,
      arguments: _emailController.text.trim().isNotEmpty
          ? _emailController.text.trim()
          : _phoneController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return AuthExperienceShell(
      heroBadge: locale.auth_signup_hero_badge,
      heroTitle: locale.auth_signup_hero_title,
      heroSubtitle: locale.auth_signup_hero_subtitle,
      sectionBadge: locale.auth_signup_section_badge,
      sectionTitle: locale.btn_signup,
      sectionDescription: locale.auth_signup_description,
      sectionIcon: Icons.person_add_alt_1_rounded,
      body: SignUpForm(
        formKey: _formKey,
        fullNameController: _fullNameController,
        phoneController: _phoneController,
        emailController: _emailController,
        passwordController: _passwordController,
        isSubmitting: _isSubmitting,
        errorMessage: _errorMessage,
        onSubmit: _submit,
      ),
      footer: AuthPromptText(
        text: locale.footer_have_account,
        actionLabel: locale.footer_action_login,
        onTap: () => context.pushReplacementNamed(AppRoutes.login),
      ),
    );
  }
}
