import 'package:dio/dio.dart';

import 'api_error_type.dart';
import 'api_exception.dart';

class ApiExceptionMapper {
  const ApiExceptionMapper._();

  static ApiException fromDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return const ApiException(
          errorType: ApiErrorType.connectionTimeout,
          message: 'error_connection_timeout',
          isTranslationKey: true,
        );
      case DioExceptionType.sendTimeout:
        return const ApiException(
          errorType: ApiErrorType.sendTimeout,
          message: 'error_send_timeout',
          isTranslationKey: true,
        );
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          errorType: ApiErrorType.receiveTimeout,
          message: 'error_receive_timeout',
          isTranslationKey: true,
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
        return fromResponse(
          statusCode: exception.response?.statusCode,
          response: exception.response?.data,
        );
      case DioExceptionType.cancel:
        return const ApiException(
          errorType: ApiErrorType.cancelled,
          message: 'error_cancelled',
          isTranslationKey: true,
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          errorType: ApiErrorType.noInternetConnection,
          message: 'error_no_internet_connection',
          isTranslationKey: true,
        );
      case DioExceptionType.unknown:
        final response = exception.response?.data;
        return ApiException(
          errorType: ApiErrorType.unknown,
          message:
              _extractMessage(response) ?? ApiErrorType.unknown.translationKey,
          response: response,
          statusCode: exception.response?.statusCode,
          isTranslationKey: _extractMessage(response) == null,
          errorCode: _extractErrorCode(response),
          title: _extractString(response, 'title'),
          detail: _extractString(response, 'detail'),
          traceId: _extractString(response, 'traceId'),
        );
    }
  }

  static ApiException fromResponse({
    required int? statusCode,
    required dynamic response,
  }) {
    final message = _extractMessage(response);
    ApiException build(
      ApiErrorType type, {
      required int? code,
      required dynamic body,
    }) {
      final resolvedMessage = message ?? type.translationKey;
      return ApiException(
        errorType: type,
        message: resolvedMessage,
        statusCode: code,
        response: body,
        isTranslationKey: message == null,
        errorCode: _extractErrorCode(body),
        title: _extractString(body, 'title'),
        detail: _extractString(body, 'detail'),
        traceId: _extractString(body, 'traceId'),
      );
    }

    switch (statusCode) {
      case 400:
        return build(ApiErrorType.badRequest, code: statusCode, body: response);
      case 401:
        return build(
          ApiErrorType.unauthorized,
          code: statusCode,
          body: response,
        );
      case 403:
        return build(ApiErrorType.forbidden, code: statusCode, body: response);
      case 404:
        return build(ApiErrorType.notFound, code: statusCode, body: response);
      case 408:
        return build(
          ApiErrorType.requestTimeout,
          code: statusCode,
          body: response,
        );
      case 409:
        return build(ApiErrorType.conflict, code: statusCode, body: response);
      case 422:
        return build(ApiErrorType.badRequest, code: statusCode, body: response);
      case 413:
        return build(
          ApiErrorType.payloadTooLarge,
          code: statusCode,
          body: response,
        );
      case 415:
        return build(
          ApiErrorType.unsupportedMediaType,
          code: statusCode,
          body: response,
        );
      case 429:
        return build(
          ApiErrorType.tooManyRequests,
          code: statusCode,
          body: response,
        );
      case 500:
        return build(
          ApiErrorType.internalServerError,
          code: statusCode,
          body: response,
        );
      case 502:
        return build(ApiErrorType.badGateway, code: statusCode, body: response);
      case 503:
        return build(
          ApiErrorType.serviceUnavailable,
          code: statusCode,
          body: response,
        );
      case 504:
        return build(
          ApiErrorType.gatewayTimeout,
          code: statusCode,
          body: response,
        );
      default:
        return build(ApiErrorType.unknown, code: statusCode, body: response);
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

  static String? _extractErrorCode(dynamic data) {
    return _extractString(data, 'errorCode');
  }

  static String? _extractString(dynamic data, String key) {
    if (data is Map<String, dynamic>) {
      final value = data[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
      return null;
    }
    if (data is Map) {
      return _extractString(Map<String, dynamic>.from(data), key);
    }
    return null;
  }
}
