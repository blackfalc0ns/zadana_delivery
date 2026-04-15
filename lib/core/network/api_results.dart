import 'package:dio/dio.dart';

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

// Future<ApiResult<T>> safeApiCall<T>(Future<T> Function() apiCall) async {
//   final bool isConnected =
//       await InternetConnectionChecker.instance.hasConnection;
//   if (!isConnected) {
//     return ApiErrorResult<T>(failure: Failure(errorMessage: 'no internet'));
//   }

//   try {
//     final result = await apiCall();
//     return ApiSuccessResult<T>(data: result);
//   } on DioException catch (dioError) {
//     return ApiErrorResult<T>(
//       failure: ServerFailure.fromDioError(dioException: dioError),
//     );
//   } catch (error) {
//     return ApiErrorResult<T>(failure: Failure(errorMessage: error.toString()));
//   }
//  }

Future<ApiResult<T>> safeApiCall<T>(Future<T> Function() apiCall) async {
  try {
    final result = await apiCall();
    return ApiSuccessResult<T>(data: result);
  } on DioException catch (dioError) {
    return ApiErrorResult<T>(
      failure: ServerFailure.fromDioError(dioException: dioError),
    );
  } catch (error) {
    return ApiErrorResult<T>(failure: Failure(errorMessage: error.toString()));
  }
}

Future<ApiResult<T>> safeLocalCall<T>(Future<T> Function() localCall) async {
  try {
    final result = await localCall();
    return ApiSuccessResult<T>(data: result);
  } catch (error) {
    return ApiErrorResult<T>(failure: Failure(errorMessage: error.toString()));
  }
}
