import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:zadana_delivery/core/errors/api_error_type.dart';
import 'package:zadana_delivery/core/errors/api_exception.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';

class FileUploadService {
  FileUploadService({ApiServices? apiServices})
    : _apiServices = apiServices ?? GetIt.instance<ApiServices>();

  final ApiServices _apiServices;

  Future<String> uploadFile(String filePath) async {
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
      final response = await _apiServices.uploadFile(multipartFile);
      final url = response.url.trim();

      if (url.isEmpty) {
        throw const ApiException(
          errorType: ApiErrorType.other,
          message: 'Upload completed without a valid file URL.',
        );
      }

      return url;
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }
}
