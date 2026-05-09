import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:zadana_delivery/core/errors/api_error_type.dart';
import 'package:zadana_delivery/core/errors/api_exception.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';

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
}

class FileUploadService {
  FileUploadService({ApiServices? apiServices})
    : _apiServices = apiServices ?? GetIt.instance<ApiServices>();

  final ApiServices _apiServices;

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
}
