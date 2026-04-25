import 'api_error_type.dart';

class ApiException implements Exception {
  //

  const ApiException({
    required this.errorType,
    required this.message,
    this.statusCode,
    this.response,
    this.isTranslationKey = false,
  });
  final ApiErrorType errorType;
  final String message;
  final int? statusCode;
  final dynamic response;
  final bool isTranslationKey;

  @override
  String toString() {
    //
    return message;
  }
}
