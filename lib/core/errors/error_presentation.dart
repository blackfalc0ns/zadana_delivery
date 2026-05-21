import 'package:flutter/widgets.dart';
import 'package:zadana_delivery/core/errors/api_error_type.dart';
import 'package:zadana_delivery/core/errors/api_exception.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

extension ApiErrorTypePresentationX on ApiErrorType {
  bool get showFullScreen {
    switch (this) {
      case ApiErrorType.noInternetConnection:
      case ApiErrorType.connectionTimeout:
      case ApiErrorType.receiveTimeout:
      case ApiErrorType.sendTimeout:
      case ApiErrorType.requestTimeout:
      case ApiErrorType.serverError:
      case ApiErrorType.internalServerError:
      case ApiErrorType.badGateway:
      case ApiErrorType.serviceUnavailable:
      case ApiErrorType.gatewayTimeout:
      case ApiErrorType.unknown:
      case ApiErrorType.other:
        return true;
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
      case ApiErrorType.cancelled:
      case ApiErrorType.locationServiceDisabled:
      case ApiErrorType.locationPermissionDenied:
      case ApiErrorType.locationPermissionDeniedForever:
      case ApiErrorType.locationPermissionNeedsSettings:
        return false;
    }
  }

  bool get showSnackBar => !showFullScreen && this != ApiErrorType.cancelled;
}

class ErrorMessagePresenter {
  const ErrorMessagePresenter._();

  static const List<String> _technicalPatterns = [
    'sql',
    'mysql',
    'database',
    'query',
    'exception',
    'stack trace',
    'stacktrace',
    'trace:',
    'traceback',
    'error:',
    'laravel',
    'eloquent',
    'sqlstate',
    'pdo',
    'select ',
    'insert ',
    'update ',
    'delete ',
    ' from ',
    ' where ',
    '.php',
    '.dart',
    '.java',
    '.kt',
    '.swift',
    '/var/',
    '/tmp/',
    'c:\\',
    'd:\\',
    ' at ',
    'line ',
    'nullreference',
    'filesystem',
    'file path',
  ];

  static String snackBarMessage(BuildContext context, ApiException exception) {
    final mappedErrorCode = _knownErrorCodeMessage(
      context,
      exception.errorCode,
    );
    if (mappedErrorCode != null) return mappedErrorCode;

    final safeMessage = safeBackendMessage(exception);
    if (safeMessage != null) return safeMessage;
    return localizedMessage(context, exception.errorType);
  }

  static String? safeBackendMessage(ApiException exception) {
    if (exception.isTranslationKey) return null;

    final message = exception.message.trim();
    if (message.isEmpty) return null;
    if (_looksTechnical(message)) return null;

    return message;
  }

  static String localizedMessage(BuildContext context, ApiErrorType errorType) {
    final l10n = context.localization;

    switch (errorType) {
      case ApiErrorType.noInternetConnection:
        return l10n.error_no_internet_connection;
      case ApiErrorType.connectionTimeout:
        return l10n.error_connection_timeout;
      case ApiErrorType.receiveTimeout:
        return l10n.error_receive_timeout;
      case ApiErrorType.sendTimeout:
        return l10n.error_send_timeout;
      case ApiErrorType.serverError:
        return l10n.error_server_error;
      case ApiErrorType.internalServerError:
        return l10n.error_internal_server_error;
      case ApiErrorType.badGateway:
        return l10n.error_bad_gateway;
      case ApiErrorType.serviceUnavailable:
        return l10n.error_service_unavailable;
      case ApiErrorType.gatewayTimeout:
        return l10n.error_gateway_timeout;
      case ApiErrorType.badRequest:
        return l10n.error_bad_request;
      case ApiErrorType.unauthorized:
        return l10n.error_unauthorized;
      case ApiErrorType.forbidden:
        return l10n.error_forbidden;
      case ApiErrorType.notFound:
        return l10n.error_not_found;
      case ApiErrorType.methodNotAllowed:
        return l10n.error_method_not_allowed;
      case ApiErrorType.notAcceptable:
        return l10n.error_not_acceptable;
      case ApiErrorType.requestTimeout:
        return l10n.error_request_timeout;
      case ApiErrorType.conflict:
        return l10n.error_conflict;
      case ApiErrorType.gone:
        return l10n.error_gone;
      case ApiErrorType.lengthRequired:
        return l10n.error_length_required;
      case ApiErrorType.preconditionFailed:
        return l10n.error_precondition_failed;
      case ApiErrorType.payloadTooLarge:
        return l10n.error_payload_too_large;
      case ApiErrorType.uriTooLong:
        return l10n.error_uri_too_long;
      case ApiErrorType.unsupportedMediaType:
        return l10n.error_unsupported_media_type;
      case ApiErrorType.rangeNotSatisfiable:
        return l10n.error_range_not_satisfiable;
      case ApiErrorType.expectationFailed:
        return l10n.error_expectation_failed;
      case ApiErrorType.tooManyRequests:
        return l10n.error_too_many_requests;
      case ApiErrorType.locationServiceDisabled:
        return l10n.location_service_disabled;
      case ApiErrorType.locationPermissionDenied:
        return l10n.location_permission_denied;
      case ApiErrorType.locationPermissionDeniedForever:
        return l10n.location_permission_denied_forever;
      case ApiErrorType.locationPermissionNeedsSettings:
        return l10n.location_permission_denied_forever;
      case ApiErrorType.unknown:
        return l10n.error_unknown;
      case ApiErrorType.cancelled:
        return l10n.error_cancelled;
      case ApiErrorType.other:
        return l10n.error_other;
    }
  }

  static bool _looksTechnical(String message) {
    final normalized = message.trim().toLowerCase();
    return _technicalPatterns.any(normalized.contains);
  }

  static String? _knownErrorCodeMessage(
    BuildContext context,
    String? errorCode,
  ) {
    switch (errorCode?.trim().toUpperCase()) {
      case 'DRIVER_PAYOUT_METHOD_REQUIRED':
        return context.localization.wallet_withdraw_blocked_no_primary;
      case 'DRIVER_COD_DEBT_NOT_SETTLED':
        return context.localization.wallet_withdraw_blocked_cod;
      case 'INSUFFICIENT_WITHDRAWABLE_BALANCE':
        return context.localization.wallet_withdraw_blocked_no_balance;
      default:
        return null;
    }
  }
}
