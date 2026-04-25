import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/core/widgets/auth/auth_experience_shell.dart';
import 'package:zadana_delivery/core/widgets/custom_snackbar.dart';
import 'package:zadana_delivery/features/auth/login/domain/entities/login_request_entity.dart';
import 'package:zadana_delivery/features/auth/login/domain/entities/login_response_entity.dart';
import 'package:zadana_delivery/features/auth/login/presentation/manager/login_event.dart';
import 'package:zadana_delivery/features/auth/login/presentation/manager/login_state.dart';
import 'package:zadana_delivery/features/auth/login/presentation/manager/login_view_model.dart';
import 'package:zadana_delivery/features/auth/login/presentation/widget/login_form.dart';

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
  late final LoginViewModel _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<LoginViewModel>();

    if ((widget.initialIdentifier ?? '').trim().isNotEmpty) {
      _identifierController.text = widget.initialIdentifier!.trim();
    }

    _identifierController.addListener(_cubit.clearError);
    _passwordController.addListener(_cubit.clearError);
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    _cubit.close();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await _submitWithCurrentValues();
  }

  Future<void> _retrySubmit() async {
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;
    if (identifier.isEmpty || password.isEmpty) {
      _cubit.clearError();
      return;
    }

    await _submitWithCurrentValues();
  }

  Future<void> _submitWithCurrentValues() async {
    FocusScope.of(context).unfocus();
    await _cubit.doIntent(
      LoginSubmitEvent(
        LoginRequestEntity(
          identifier: _identifierController.text.trim(),
          password: _passwordController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<LoginViewModel, LoginState>(
        listener: (context, state) {
          final response = state.response;
          if (state.isSuccess && response != null) {
            context.pushNamedAndRemoveUntil(
              _resolveSuccessRoute(response),
              predicate: (route) => false,
            );
            return;
          }

          final failure = state.failure;
          if (!state.isLoading &&
              failure != null &&
              !_shouldShowFullScreenError(failure)) {
            CustomSnackbar.showError(
              context: context,
              message: failure.errorMessage,
            );
          }
        },
        builder: (context, state) {
          if (!state.isLoading &&
              state.failure != null &&
              _shouldShowFullScreenError(state.failure!)) {
            return Scaffold(
              backgroundColor: context.colorScheme.surface,
              body: SafeArea(
                child: ApiErrorWidget.fromFailure(
                  state.failure!,
                  onRetry: _retrySubmit,
                  onGoBack: _cubit.clearError,
                ),
              ),
            );
          }

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
              isSubmitting: state.isLoading,
              onSubmit: _submit,
              onForgotPassword: () =>
                  context.pushNamed(AppRoutes.forgetPassword),
            ),
            footer: AuthPromptText(
              text: locale.footer_no_account,
              actionLabel: locale.footer_action_signup,
              onTap: () => context.pushNamed(AppRoutes.signUp),
            ),
          );
        },
      ),
    );
  }

  String _resolveSuccessRoute(LoginResponseEntity response) {
    final driverStatus = response.driverStatus;
    if (driverStatus?.isPendingReview == true) {
      return AppRoutes.accountPendingApproval;
    }
    if (driverStatus?.isBlocked == true) {
      return AppRoutes.accountBlocked;
    }
    if ((driverStatus?.primaryZoneId ?? '').trim().isEmpty) {
      return AppRoutes.driverProfileCompletion;
    }
    return AppRoutes.mainShell;
  }

  bool _shouldShowFullScreenError(Failure failure) {
    final code = failure.normalizedCode;

    if (failure.isConnectivityIssue) return true;

    return code == 'unknown' ||
        code == 'error_unknown' ||
        code == 'cancelled' ||
        code == 'error_cancelled' ||
        code == 'other' ||
        code == 'error_other' ||
        code == 'bad_certificate' ||
        code == 'error_bad_certificate' ||
        code == 'no_response' ||
        code == 'error_no_response';
  }
}
