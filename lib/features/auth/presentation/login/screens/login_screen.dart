import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/auth/presentation/login/widgets/login_form.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_experience_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.initialIdentifier});

  final String? initialIdentifier;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if ((widget.initialIdentifier ?? '').trim().isNotEmpty) {
      _identifierController.text = widget.initialIdentifier!.trim();
    }

    _identifierController.addListener(_clearError);
    _passwordController.addListener(_clearError);
  }

  @override
  void dispose() {
    _identifierController.dispose();
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
    context.pushNamed(AppRoutes.driverProfileCompletion);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return AuthExperienceShell(
      heroBadge: locale.auth_login_hero_badge,
      heroTitle: locale.auth_login_hero_title,
      heroSubtitle: locale.auth_login_hero_subtitle,
      sectionBadge: locale.auth_login_section_badge,
      sectionTitle: locale.auth_title,
      sectionDescription: locale.auth_login_description,
      sectionIcon: Icons.delivery_dining_rounded,
      body: LoginForm(
        formKey: _formKey,
        emailOrPhoneController: _identifierController,
        passwordController: _passwordController,
        isSubmitting: _isSubmitting,
        errorMessage: _errorMessage,
        onSubmit: _submit,
        onForgotPassword: () => context.pushNamed(AppRoutes.forgetPassword),
      ),
      footer: AuthPromptText(
        text: locale.footer_no_account,
        actionLabel: locale.footer_action_signup,
        onTap: () => context.pushNamed(AppRoutes.signUp),
      ),
    );
  }
}
