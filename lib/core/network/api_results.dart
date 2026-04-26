import 'package:dio/dio.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:zadana_delivery/core/errors/api_error_type.dart';
import 'package:zadana_delivery/core/errors/api_exception.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';

import 'failures.dart';

sealed class ApiResult<T> {}

class ApiSuccessResult<T> extends ApiResult<T> {
  ApiSuccessResult({required this.data});
  final T data;
}

class ApiErrorResult<T> extends ApiResult<T> {
  ApiErrorResult({required this.failure});
  final Failure failure;
}

Future<ApiResult<T>> safeApiCall<T>(Future<T> Function() apiCall) async {
  try {
    final hasConnection = await InternetConnection().hasInternetAccess;
    if (!hasConnection) {
      throw const ApiException(
        errorType: ApiErrorType.noInternetConnection,
        message: 'No internet connection.',
      );
    }

    final result = await apiCall();
    return ApiSuccessResult<T>(data: result);
  } on ApiException catch (exception) {
    return ApiErrorResult<T>(
      failure: Failure(
        errorMessage: _resolveApiErrorMessage(exception),
        code: exception.errorType.name,
        exception: exception,
      ),
    );
  } on DioException catch (dioError) {
    final exception = ApiExceptionMapper.fromDioException(dioError);
    return ApiErrorResult<T>(
      failure: Failure(
        errorMessage: _resolveApiErrorMessage(exception),
        code: exception.errorType.name,
        exception: exception,
      ),
    );
  } catch (error) {
    const exception = ApiException(
      errorType: ApiErrorType.unknown,
      message: 'error_unknown',
      isTranslationKey: true,
    );
    return ApiErrorResult<T>(
      failure: Failure(
        errorMessage: _resolveApiErrorMessage(exception),
        code: exception.errorType.name,
        exception: exception,
      ),
    );
  }
}

String _resolveApiErrorMessage(ApiException exception) {
  if (exception.isTranslationKey) {
    return exception.errorType.translationKey;
  }
  return exception.message.trim();
}

Future<ApiResult<T>> safeLocalCall<T>(Future<T> Function() localCall) async {
  try {
    final result = await localCall();
    return ApiSuccessResult<T>(data: result);
  } catch (error) {
    return ApiErrorResult<T>(failure: Failure(errorMessage: error.toString()));
  }
}
