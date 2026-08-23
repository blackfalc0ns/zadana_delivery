import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zadana_delivery/core/network/api_services.dart';
import 'package:zadana_delivery/core/network/retry_with_backoff.dart';
import 'package:zadana_delivery/core/services/file_upload_service.dart';
import 'package:zadana_delivery/core/services/language_interceptor.dart';
import 'package:zadana_delivery/features/auth/data/driver_profile_service.dart';

import '../services/token_interceptor.dart';
import 'network_constants.dart';

@module
abstract class ExternalModules {
  @lazySingleton
  Dio provideDio(
    TokenInterceptor tokenInterceptor,
    LanguageInterceptor languageInterceptor,
  ) {
    final dio = Dio();

    dio.options.baseUrl = NetworkConstants.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    dio.interceptors.add(languageInterceptor);
    dio.interceptors.add(tokenInterceptor);
    dio.interceptors.add(RetryWithBackoffInterceptor());
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
        ),
      );
    }

    return dio;
  }

  @Named('osmDio')
  @lazySingleton
  Dio provideOsmDio() {
    final dio = Dio();

    dio.options.baseUrl = 'https://nominatim.openstreetmap.org';
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': 'zadana-user-app',
    };

    return dio;
  }

  @Named('refreshDio')
  @lazySingleton
  Dio provideRefreshDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: NetworkConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
        ),
      );
    }

    return dio;
  }

  @preResolve
  Future<SharedPreferences> get provideSharedPreferences async {
    return SharedPreferences.getInstance();
  }

  @lazySingleton
  FlutterSecureStorage flutterSecureStorage() {
    return const FlutterSecureStorage();
  }

  @lazySingleton
  DriverIdentityService provideDriverIdentityService() =>
      DriverIdentityService();

  @lazySingleton
  DriverProfileDraftService provideDriverProfileDraftService() =>
      DriverProfileDraftService();

  @lazySingleton
  FileUploadService provideFileUploadService(ApiServices apiServices, Dio dio) {
    return FileUploadService(apiServices: apiServices, dio: dio);
  }

  @lazySingleton
  ImagePicker provideImagePicker() {
    return ImagePicker();
  }
}
