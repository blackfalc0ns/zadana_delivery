import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zadana_delivery/core/services/language_interceptor.dart';
import '../services/token_interceptor.dart';
import 'network_constants.dart';

@module
abstract class ExternalModules {
  @lazySingleton
  Dio provideDio(
    PrettyDioLogger prettyDioLogger,
    TokenInterceptor tokenInterceptor,
    LanguageInterceptor languageInterceptor,
  ) {
    final dio = Dio();

    dio.options.baseUrl = NetworkConstants.baseUrl;
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    dio.interceptors.add(languageInterceptor);
    dio.interceptors.add(tokenInterceptor);
    dio.interceptors.add(prettyDioLogger);

    return dio;
  }

  @Named('osmDio')
  @lazySingleton
  Dio provideOsmDio(PrettyDioLogger prettyDioLogger) {
    final dio = Dio();

    dio.options.baseUrl = 'https://nominatim.openstreetmap.org';
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': 'zadana-user-app',
    };

    dio.interceptors.add(prettyDioLogger);

    return dio;
  }

  @lazySingleton
  PrettyDioLogger providePrettyDioLogger() {
    return PrettyDioLogger(requestHeader: true, requestBody: true);
  }

  @preResolve
  Future<SharedPreferences> get provideSharedPreferences async {
    return SharedPreferences.getInstance();
  }

  @lazySingleton
  FlutterSecureStorage flutterSecureStorage() {
    return const FlutterSecureStorage();
  }
}
