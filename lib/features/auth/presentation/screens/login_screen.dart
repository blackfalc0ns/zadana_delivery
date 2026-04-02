import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/auth_experience_shell.dart';
import 'package:zadana_delivery/features/auth/presentation/widgets/login_form.dart';

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

  String _copy(BuildContext context, String ar, String en) {
    return Localizations.localeOf(context).languageCode == 'ar' ? ar : en;
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
      heroBadge: _copy(context, 'جاهز للتوصيل', 'Ready to deliver'),
      heroTitle: _copy(context, 'تسجيل دخول المندوب', 'Driver sign in'),
      heroSubtitle: _copy(
        context,
        'ادخل لحسابك لاستلام الطلبات الجديدة، ومتابعة نشاطك، ثم استكمال بيانات المركبة بسهولة.',
        'Access new delivery requests, manage your activity, and continue to the vehicle setup step.',
      ),
      sectionBadge: _copy(context, 'حساب المندوب', 'Driver account'),
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
