import 'package:dio/dio.dart';

import 'api_error_type.dart';
import 'api_exception.dart';

class ApiExceptionMapper {
  const ApiExceptionMapper._();

  static ApiException fromDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          errorType: ApiErrorType.connectionTimeout,
          message: 'Connection timeout with API server.',
          response: exception.response?.data,
          statusCode: exception.response?.statusCode,
        );
      case DioExceptionType.sendTimeout:
        return ApiException(
          errorType: ApiErrorType.sendTimeout,
          message: 'Send timeout with API server.',
          response: exception.response?.data,
          statusCode: exception.response?.statusCode,
        );
      case DioExceptionType.receiveTimeout:
        return ApiException(
          errorType: ApiErrorType.receiveTimeout,
          message: 'Receive timeout with API server.',
          response: exception.response?.data,
          statusCode: exception.response?.statusCode,
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
        return fromResponse(
          statusCode: exception.response?.statusCode,
          response: exception.response?.data,
        );
      case DioExceptionType.cancel:
        return ApiException(
          errorType: ApiErrorType.cancelled,
          message: 'Request to API server was cancelled.',
          response: exception.response?.data,
          statusCode: exception.response?.statusCode,
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          errorType: ApiErrorType.noInternetConnection,
          message: 'No internet connection.',
        );
      case DioExceptionType.unknown:
        return ApiException(
          errorType: ApiErrorType.unknown,
          message: _extractMessage(exception.response?.data) ?? exception.message ?? 'Unexpected error occurred. Please try again later.',
          response: exception.response?.data,
          statusCode: exception.response?.statusCode,
        );
    }
  }

  static ApiException fromResponse({
    required int? statusCode,
    required dynamic response,
  }) {
    final message = _extractMessage(response);

    switch (statusCode) {
      case 400:
        return ApiException(
          errorType: ApiErrorType.badRequest,
          message: message ?? 'Bad request.',
          statusCode: statusCode,
          response: response,
        );
      case 401:
        return ApiException(
          errorType: ApiErrorType.unauthorized,
          message: message ?? 'Unauthorized.',
          statusCode: statusCode,
          response: response,
        );
      case 403:
        return ApiException(
          errorType: ApiErrorType.forbidden,
          message: message ?? 'Forbidden.',
          statusCode: statusCode,
          response: response,
        );
      case 404:
        return ApiException(
          errorType: ApiErrorType.notFound,
          message: message ?? 'Resource not found.',
          statusCode: statusCode,
          response: response,
        );
      case 408:
        return ApiException(
          errorType: ApiErrorType.requestTimeout,
          message: message ?? 'Request timeout.',
          statusCode: statusCode,
          response: response,
        );
      case 409:
        return ApiException(
          errorType: ApiErrorType.conflict,
          message: message ?? 'Conflict occurred.',
          statusCode: statusCode,
          response: response,
        );
      case 413:
        return ApiException(
          errorType: ApiErrorType.payloadTooLarge,
          message: message ?? 'Payload is too large.',
          statusCode: statusCode,
          response: response,
        );
      case 415:
        return ApiException(
          errorType: ApiErrorType.unsupportedMediaType,
          message: message ?? 'Unsupported media type.',
          statusCode: statusCode,
          response: response,
        );
      case 429:
        return ApiException(
          errorType: ApiErrorType.tooManyRequests,
          message: message ?? 'Too many requests.',
          statusCode: statusCode,
          response: response,
        );
      case 500:
        return ApiException(
          errorType: ApiErrorType.internalServerError,
          message: message ?? 'Server error. Please try again later.',
          statusCode: statusCode,
          response: response,
        );
      case 502:
        return ApiException(
          errorType: ApiErrorType.badGateway,
          message: message ?? 'Bad gateway.',
          statusCode: statusCode,
          response: response,
        );
      case 503:
        return ApiException(
          errorType: ApiErrorType.serviceUnavailable,
          message: message ?? 'Service unavailable.',
          statusCode: statusCode,
          response: response,
        );
      case 504:
        return ApiException(
          errorType: ApiErrorType.gatewayTimeout,
          message: message ?? 'Gateway timeout.',
          statusCode: statusCode,
          response: response,
        );
      default:
        return ApiException(
          errorType: ApiErrorType.unknown,
          message: message ?? 'Unexpected server error.',
          statusCode: statusCode,
          response: response,
        );
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      for (final key in ['detail', 'message', 'error', 'title']) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) {
          return value;
        }
      }
    }

    if (data is Map) {
      return _extractMessage(Map<String, dynamic>.from(data));
    }

    return null;
  }
}
