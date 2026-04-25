enum ApiErrorType {
  // Network errors
  noInternetConnection,
  connectionTimeout,
  receiveTimeout,
  sendTimeout,

  // Server errors
  serverError,
  internalServerError,
  badGateway,
  serviceUnavailable,
  gatewayTimeout,

  // Client errors
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  methodNotAllowed,
  notAcceptable,
  requestTimeout,
  conflict,
  gone,
  lengthRequired,
  preconditionFailed,
  payloadTooLarge,
  uriTooLong,
  unsupportedMediaType,
  rangeNotSatisfiable,
  expectationFailed,
  tooManyRequests,

  // Other errors
  locationServiceDisabled,
  locationPermissionDenied,
  locationPermissionDeniedForever,
  unknown,
  cancelled,
  other,
}

extension ApiErrorTypeExtension on ApiErrorType {
  String get translationKey {
    switch (this) {
      case ApiErrorType.noInternetConnection:
        return 'error_no_internet_connection';
      case ApiErrorType.connectionTimeout:
        return 'error_connection_timeout';
      case ApiErrorType.receiveTimeout:
        return 'error_receive_timeout';
      case ApiErrorType.sendTimeout:
        return 'error_send_timeout';
      case ApiErrorType.serverError:
        return 'error_server_error';
      case ApiErrorType.internalServerError:
        return 'error_internal_server_error';
      case ApiErrorType.badGateway:
        return 'error_bad_gateway';
      case ApiErrorType.serviceUnavailable:
        return 'error_service_unavailable';
      case ApiErrorType.gatewayTimeout:
        return 'error_gateway_timeout';
      case ApiErrorType.badRequest:
        return 'error_bad_request';
      case ApiErrorType.unauthorized:
        return 'error_unauthorized';
      case ApiErrorType.forbidden:
        return 'error_forbidden';
      case ApiErrorType.notFound:
        return 'error_not_found';
      case ApiErrorType.methodNotAllowed:
        return 'error_method_not_allowed';
      case ApiErrorType.notAcceptable:
        return 'error_not_acceptable';
      case ApiErrorType.requestTimeout:
        return 'error_request_timeout';
      case ApiErrorType.conflict:
        return 'error_conflict';
      case ApiErrorType.gone:
        return 'error_gone';
      case ApiErrorType.lengthRequired:
        return 'error_length_required';
      case ApiErrorType.preconditionFailed:
        return 'error_precondition_failed';
      case ApiErrorType.payloadTooLarge:
        return 'error_payload_too_large';
      case ApiErrorType.uriTooLong:
        return 'error_uri_too_long';
      case ApiErrorType.unsupportedMediaType:
        return 'error_unsupported_media_type';
      case ApiErrorType.rangeNotSatisfiable:
        return 'error_range_not_satisfiable';
      case ApiErrorType.expectationFailed:
        return 'error_expectation_failed';
      case ApiErrorType.tooManyRequests:
        return 'error_too_many_requests';
      case ApiErrorType.locationServiceDisabled:
        return 'location_service_disabled';
      case ApiErrorType.locationPermissionDenied:
        return 'location_permission_denied';
      case ApiErrorType.locationPermissionDeniedForever:
        return 'location_permission_denied_forever';
      case ApiErrorType.unknown:
        return 'error_unknown';
      case ApiErrorType.cancelled:
        return 'error_cancelled';
      case ApiErrorType.other:
        return 'error_other';
    }
  }
}
