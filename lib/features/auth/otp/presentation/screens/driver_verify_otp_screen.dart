import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_presentation.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/auth/auth_experience_shell.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/auth/login/domain/entities/login_response_entity.dart';
import 'package:zadana_delivery/features/auth/otp/domain/entities/resend_driver_otp_request_entity.dart';
import 'package:zadana_delivery/features/auth/otp/domain/entities/verify_driver_otp_request_entity.dart';
import 'package:zadana_delivery/features/auth/otp/presentation/manager/driver_verify_otp_event.dart';
import 'package:zadana_delivery/features/auth/otp/presentation/manager/driver_verify_otp_state.dart';
import 'package:zadana_delivery/features/auth/otp/presentation/manager/driver_verify_otp_view_model.dart';
import 'package:zadana_delivery/features/auth/otp/presentation/widgets/driver_verify_otp_form.dart';

class DriverVerifyOtpScreen extends StatefulWidget {
  const DriverVerifyOtpScreen({
    super.key,
    required this.identifier,
    this.initialMessage,
  });

  final String identifier;
  final String? initialMessage;

  @override
  State<DriverVerifyOtpScreen> createState() => _DriverVerifyOtpScreenState();
}

class _DriverVerifyOtpScreenState extends State<DriverVerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  late final DriverVerifyOtpViewModel _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<DriverVerifyOtpViewModel>();
    _otpController.addListener(() {
      _cubit.clearError();
      _cubit.clearResendFeedback();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final message = widget.initialMessage?.trim() ?? '';
      if (!mounted || message.isEmpty) return;
      CustomSnackbar.showInfo(context: context, message: message);
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _cubit.close();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    await _cubit.doIntent(
      DriverVerifyOtpSubmitEvent(
        VerifyDriverOtpRequestEntity(
          identifier: widget.identifier,
          otpCode: _otpController.text.trim(),
        ),
      ),
    );
  }

  Future<void> _retrySubmit() async {
    if (_otpController.text.trim().length != 4) {
      _cubit.clearError();
      return;
    }
    await _submit();
  }

  Future<void> _resend() async {
    FocusScope.of(context).unfocus();
    await _cubit.doIntent(
      DriverVerifyOtpResendEvent(
        ResendDriverOtpRequestEntity(identifier: widget.identifier),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<DriverVerifyOtpViewModel, DriverVerifyOtpState>(
        listenWhen: (previous, current) =>
            previous.isSuccess != current.isSuccess ||
            previous.response != current.response ||
            previous.failure != current.failure ||
            previous.resendFailure != current.resendFailure ||
            previous.resendMessage != current.resendMessage,
        listener: (context, state) {
          final response = state.response;
          if (state.isSuccess && response != null) {
            final targetRoute = _resolveSuccessRoute(response);
            context.pushNamedAndRemoveUntil(
              targetRoute,
              rootNavigator: true,
              predicate: (route) => false,
              arguments: _resolveSuccessRouteArguments(
                route: targetRoute,
                response: response,
              ),
            );
            return;
          }

          final resendMessage = state.resendMessage?.trim() ?? '';
          if (resendMessage.isNotEmpty) {
            CustomSnackbar.showSuccess(
              context: context,
              message: resendMessage,
            );
            _cubit.clearResendFeedback();
            return;
          }

          final resendException = state.resendFailure?.asException;
          if (!state.isResending && resendException != null) {
            CustomSnackbar.showError(
              context: context,
              message: ErrorMessagePresenter.snackBarMessage(
                context,
                resendException,
              ),
            );
            _cubit.clearResendFeedback();
            return;
          }

          final exception = state.failure?.asException;
          if (!state.isLoading &&
              exception != null &&
              exception.errorType.showSnackBar) {
            CustomSnackbar.showError(
              context: context,
              message: ErrorMessagePresenter.snackBarMessage(
                context,
                exception,
              ),
            );
          }
        },
        builder: (context, state) {
          final exception = state.failure?.asException;
          if (!state.isLoading &&
              exception != null &&
              exception.errorType.showFullScreen) {
            return Scaffold(
              backgroundColor: context.colorScheme.surface,
              body: SafeArea(
                child: ApiErrorWidget(
                  exception: exception,
                  onRetry: _retrySubmit,
                  onGoBack: _cubit.clearError,
                ),
              ),
            );
          }

          return Stack(
            children: [
              AuthExperienceShell(
                showBackButton: true,
                onBackPressed: state.isLoading
                    ? null
                    : () => context.pushNamedAndRemoveUntil(
                        AppRoutes.login,
                        rootNavigator: true,
                        predicate: (route) => false,
                        arguments: widget.identifier,
                      ),
                heroBadge: locale.auth_verify_otp_hero_badge,
                heroTitle: locale.auth_verify_otp_hero_title,
                heroSubtitle: locale.auth_verify_otp_hero_subtitle,
                sectionBadge: locale.auth_verify_otp_section_badge,
                sectionTitle: locale.auth_verify_otp_section_title,
                sectionDescription: locale.auth_verify_otp_section_description,
                sectionIcon: Icons.verified_user_outlined,
                body: DriverVerifyOtpForm(
                  formKey: _formKey,
                  identifier: widget.identifier,
                  otpController: _otpController,
                  isSubmitting: state.isLoading,
                  isResending: state.isResending,
                  onSubmit: _submit,
                  onResend: _resend,
                ),
              ),
              if (state.isLoading) ...[
                Positioned.fill(
                  child: AbsorbPointer(
                    child: ColoredBox(
                      color: Colors.black.withValues(alpha: 0.10),
                    ),
                  ),
                ),
                const Positioned.fill(child: CustomProgressIndicator()),
              ],
            ],
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
    if (driverStatus?.shouldGoHome == true) {
      return AppRoutes.mainShell;
    }
    if (driverStatus?.hasCompletedProfile != true) {
      return AppRoutes.driverProfileCompletion;
    }
    return AppRoutes.mainShell;
  }

  Object? _resolveSuccessRouteArguments({
    required String route,
    required LoginResponseEntity response,
  }) {
    switch (route) {
      case AppRoutes.accountPendingApproval:
      case AppRoutes.accountBlocked:
        return response.driverStatus;
      default:
        return null;
    }
  }
}
