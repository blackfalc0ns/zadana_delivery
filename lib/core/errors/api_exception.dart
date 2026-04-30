import 'api_error_type.dart';

class ApiException implements Exception {
  //

  const ApiException({
    required this.errorType,
    required this.message,
    this.statusCode,
    this.response,
    this.isTranslationKey = false,
    this.errorCode,
    this.title,
    this.detail,
    this.traceId,
  });
  final ApiErrorType errorType;
  final String message;
  final int? statusCode;
  final dynamic response;
  final bool isTranslationKey;
  final String? errorCode;
  final String? title;
  final String? detail;
  final String? traceId;

  @override
  String toString() {
    //
    return message;
  }
}
