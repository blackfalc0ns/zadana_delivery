import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/errors/api_error_type.dart';
import 'package:zadana_delivery/core/errors/api_exception.dart';
import 'package:zadana_delivery/core/errors/error_presentation.dart';

import 'client_error_widget.dart';
import 'generic_error_widget.dart';
import 'no_internet_error_widget.dart';
import 'server_error_widget.dart';
import 'timeout_error_widget.dart';

class ApiErrorWidget extends StatelessWidget {
  const ApiErrorWidget({
    super.key,
    required this.exception,
    this.onRetry,
    this.onGoBack,
    this.onContactSupport,
    this.onCheckConnection,
  });
  final ApiException exception;
  final VoidCallback? onRetry;
  final VoidCallback? onGoBack;
  final VoidCallback? onContactSupport;
  final VoidCallback? onCheckConnection;

  @override
  Widget build(BuildContext context) {
    switch (exception.errorType) {
      // Network errors
      case ApiErrorType.noInternetConnection:
        return NoInternetErrorWidget(onRetry: onRetry);

      // Timeout errors
      case ApiErrorType.connectionTimeout:
      case ApiErrorType.receiveTimeout:
      case ApiErrorType.sendTimeout:
      case ApiErrorType.requestTimeout:
        return TimeoutErrorWidget(
          timeoutType: exception.errorType,
          onRetry: onRetry,
        );

      // Server errors
      case ApiErrorType.serverError:
      case ApiErrorType.internalServerError:
      case ApiErrorType.badGateway:
      case ApiErrorType.serviceUnavailable:
      case ApiErrorType.gatewayTimeout:
        return ServerErrorWidget(
          serverErrorType: exception.errorType,
          statusCode: exception.statusCode,
          serverMessage: ErrorMessagePresenter.safeBackendMessage(exception),
          onRetry: onRetry,
          onContactSupport: onContactSupport,
        );

      // Client errors
      case ApiErrorType.badRequest:
      case ApiErrorType.unauthorized:
      case ApiErrorType.forbidden:
      case ApiErrorType.notFound:
      case ApiErrorType.methodNotAllowed:
      case ApiErrorType.notAcceptable:
      case ApiErrorType.conflict:
      case ApiErrorType.gone:
      case ApiErrorType.lengthRequired:
      case ApiErrorType.preconditionFailed:
      case ApiErrorType.payloadTooLarge:
      case ApiErrorType.uriTooLong:
      case ApiErrorType.unsupportedMediaType:
      case ApiErrorType.rangeNotSatisfiable:
      case ApiErrorType.expectationFailed:
      case ApiErrorType.tooManyRequests:
        return ClientErrorWidget(
          clientErrorType: exception.errorType,
          statusCode: exception.statusCode,
          serverMessage: ErrorMessagePresenter.safeBackendMessage(exception),
          onRetry: onRetry,
          onGoBack: onGoBack,
        );

      // Generic errors
      case ApiErrorType.unknown:
      case ApiErrorType.cancelled:
      case ApiErrorType.other:
      case ApiErrorType.locationServiceDisabled:
      case ApiErrorType.locationPermissionDenied:
      case ApiErrorType.locationPermissionDeniedForever:
        return GenericErrorWidget(
          errorType: exception.errorType,
          serverMessage: ErrorMessagePresenter.safeBackendMessage(exception),
          onRetry: onRetry,
          onGoBack: onGoBack,
        );
    }
  }
}
