import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../services/language_service.dart';

@injectable
class LanguageInterceptor extends Interceptor {
  LanguageInterceptor(this._languageService);
  final LanguageService _languageService;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final languageCode = _languageService.getLanguageCode();

    options.headers['Accept-Language'] = languageCode;

    log('Language Header Sent: $languageCode', name: 'LanguageInterceptor');

    handler.next(options);
  }
}
