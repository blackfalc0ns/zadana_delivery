import 'package:zadana_delivery/core/errors/api_error_type.dart';
import 'package:zadana_delivery/core/errors/api_exception.dart';
import 'package:zadana_delivery/core/network/failures.dart';

class FailureExceptionMapper {
  const FailureExceptionMapper._();

  static ApiException fromFailure(Failure failure) {
    if (failure.exception != null) return failure.exception!;

    final normalizedCode = failure.code.trim().toLowerCase();
    final statusCode = int.tryParse(normalizedCode);
    final errorType = _mapErrorType(normalizedCode, statusCode);
    final isTranslationKey = failure.errorMessage == errorType.translationKey;

    return ApiException(
      errorType: errorType,
      message: isTranslationKey
          ? errorType.translationKey
          : failure.errorMessage,
      statusCode: statusCode,
      isTranslationKey: isTranslationKey,
    );
  }

  static ApiErrorType _mapErrorType(String normalizedCode, int? statusCode) {
    switch (normalizedCode) {
      case 'error_no_internet_connection':
      case 'error_no_internet':
      case 'connection_error':
      case 'nointernetconnection':
      case 'no_internet_connection':
        return ApiErrorType.noInternetConnection;
      case 'error_connection_timeout':
      case 'connection_timeout':
        return ApiErrorType.connectionTimeout;
      case 'error_send_timeout':
      case 'send_timeout':
        return ApiErrorType.sendTimeout;
      case 'error_receive_timeout':
      case 'receive_timeout':
        return ApiErrorType.receiveTimeout;
      case 'error_request_timeout':
      case 'request_timeout':
        return ApiErrorType.requestTimeout;
      case 'error_cancelled':
      case 'error_request_cancelled':
      case 'request_cancelled':
      case 'cancelled':
        return ApiErrorType.cancelled;
      case 'error_bad_request':
      case '400':
      case '422':
        return ApiErrorType.badRequest;
      case 'error_unauthorized':
      case '401':
        return ApiErrorType.unauthorized;
      case 'error_forbidden':
      case '403':
        return ApiErrorType.forbidden;
      case 'error_not_found':
      case '404':
        return ApiErrorType.notFound;
      case 'error_conflict':
      case '409':
        return ApiErrorType.conflict;
      case 'error_payload_too_large':
      case '413':
        return ApiErrorType.payloadTooLarge;
      case 'error_unsupported_media_type':
      case '415':
        return ApiErrorType.unsupportedMediaType;
      case 'error_too_many_requests':
      case '429':
        return ApiErrorType.tooManyRequests;
      case 'error_server_error':
      case '500':
        return ApiErrorType.internalServerError;
      case 'error_bad_gateway':
      case '502':
        return ApiErrorType.badGateway;
      case 'error_service_unavailable':
      case '503':
        return ApiErrorType.serviceUnavailable;
      case 'error_gateway_timeout':
      case '504':
        return ApiErrorType.gatewayTimeout;
      case 'error_no_response':
      case 'no_response':
        return ApiErrorType.serverError;
      case 'location_service_disabled':
        return ApiErrorType.locationServiceDisabled;
      case 'location_permission_denied':
        return ApiErrorType.locationPermissionDenied;
      case 'location_permission_denied_forever':
        return ApiErrorType.locationPermissionDeniedForever;
      case 'location_permission_needs_settings':
        return ApiErrorType.locationPermissionNeedsSettings;
      case 'error_other':
      case 'other':
        return ApiErrorType.other;
      case 'error_unknown':
      case 'unknown':
      default:
        if (statusCode == 502) return ApiErrorType.badGateway;
        if (statusCode == 503) return ApiErrorType.serviceUnavailable;
        if (statusCode == 504) return ApiErrorType.gatewayTimeout;
        if (statusCode != null && statusCode >= 500) {
          return ApiErrorType.internalServerError;
        }
        return ApiErrorType.unknown;
    }
  }
}
