import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:zadana_delivery/core/errors/api_error_type.dart';
import 'package:zadana_delivery/core/errors/api_exception.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';
import 'package:zadana_delivery/core/network/network_constants.dart';
import 'package:zadana_delivery/core/services/registration_upload_token_service.dart';
import 'package:zadana_delivery/core/services/token_interceptor.dart';

enum DriverUploadDirectory { nationalId, license, vehicle, profile, proofs }

extension DriverUploadDirectoryValue on DriverUploadDirectory {
  String get value {
    switch (this) {
      case DriverUploadDirectory.nationalId:
        return 'drivers/national-id';
      case DriverUploadDirectory.license:
        return 'drivers/license';
      case DriverUploadDirectory.vehicle:
        return 'drivers/vehicle';
      case DriverUploadDirectory.profile:
        return 'drivers/profile';
      case DriverUploadDirectory.proofs:
        return 'drivers/proofs';
    }
  }

  /// Whether this directory requires a Registration Upload Token
  /// (used during registration before the driver has a JWT).
  bool get requiresRegistrationToken {
    switch (this) {
      case DriverUploadDirectory.nationalId:
      case DriverUploadDirectory.license:
      case DriverUploadDirectory.vehicle:
      case DriverUploadDirectory.profile:
        return true;
      case DriverUploadDirectory.proofs:
        return false;
    }
  }
}

class FileUploadService {
  FileUploadService({ApiServices? apiServices, Dio? dio})
      : _apiServices = apiServices ?? GetIt.instance<ApiServices>(),
        _dio = dio ?? GetIt.instance<Dio>();

  final ApiServices _apiServices;
  final Dio _dio;

  /// Uploads a file using the driver's JWT (for authenticated drivers).
  /// Used for `drivers/proofs` and document re-uploads after registration.
  Future<String> uploadFile(
    String filePath, {
    required DriverUploadDirectory directory,
  }) async {
    final normalizedPath = filePath.trim();
    final file = File(normalizedPath);

    if (normalizedPath.isEmpty || !file.existsSync()) {
      throw const ApiException(
        errorType: ApiErrorType.badRequest,
        message: 'Selected file was not found.',
      );
    }

    try {
      final fileName = file.uri.pathSegments.isEmpty
          ? 'upload.jpg'
          : file.uri.pathSegments.last;
      final multipartFile = await MultipartFile.fromFile(
        normalizedPath,
        filename: fileName,
      );
      debugPrint('[FileUpload] Uploading file: $normalizedPath');
      debugPrint('[FileUpload] Upload directory: ${directory.value}');
      final response = await _apiServices.uploadFile(
        directory.value.trim(),
        multipartFile,
      );
      final url = response.url.trim();

      if (url.isEmpty) {
        throw const ApiException(
          errorType: ApiErrorType.other,
          message: 'Upload completed without a valid file URL.',
        );
      }

      return url;
    } on DioException catch (exception) {
      debugPrint('[FileUpload] Upload failed');
      debugPrint('[FileUpload] Request data: ${exception.requestOptions.data}');
      debugPrint('[FileUpload] Response: ${exception.response?.data}');
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  /// Uploads a file using a Registration Upload Token (for new drivers
  /// during registration who don't yet have a JWT).
  ///
  /// The [deviceId] is used to obtain/refresh the registration upload token.
  Future<String> uploadRegistrationFile(
    String filePath, {
    required DriverUploadDirectory directory,
    required String deviceId,
    required RegistrationUploadTokenService tokenService,
  }) async {
    final normalizedPath = filePath.trim();
    final file = File(normalizedPath);

    if (normalizedPath.isEmpty || !file.existsSync()) {
      throw const ApiException(
        errorType: ApiErrorType.badRequest,
        message: 'Selected file was not found.',
      );
    }

    try {
      final token = await tokenService.ensureToken(deviceId);
      final headerName = tokenService.headerName;

      final fileName = file.uri.pathSegments.isEmpty
          ? 'upload.jpg'
          : file.uri.pathSegments.last;
      final multipartFile = await MultipartFile.fromFile(
        normalizedPath,
        filename: fileName,
      );

      debugPrint('[FileUpload] Registration upload: $normalizedPath');
      debugPrint('[FileUpload] Upload directory: ${directory.value}');

      final formData = FormData.fromMap({
        'file': multipartFile,
        'directory': directory.value.trim(),
      });

      final response = await _dio.post<dynamic>(
        EndPoints.fileUpload,
        data: formData,
        options: Options(
          headers: {headerName: token},
          extra: {TokenInterceptor.skipAuthKey: true},
        ),
      );

      final data = response.data;
      final map = data is Map<String, dynamic>
          ? data
          : data is Map
              ? Map<String, dynamic>.from(data)
              : const <String, dynamic>{};

      final url = (map['url'] as String?)?.trim() ?? '';

      if (url.isEmpty) {
        throw const ApiException(
          errorType: ApiErrorType.other,
          message: 'Upload completed without a valid file URL.',
        );
      }

      return url;
    } on ApiException {
      rethrow;
    } on DioException catch (exception) {
      debugPrint('[FileUpload] Registration upload failed');
      debugPrint('[FileUpload] Response: ${exception.response?.data}');
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }
}
