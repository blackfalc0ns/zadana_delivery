import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';

import '../models/driver_unified_profile_model_dto.dart';
import '../models/update_driver_documents_request_model_dto.dart';
import '../models/update_driver_personal_request_model_dto.dart';
import '../models/update_driver_vehicle_request_model_dto.dart';
import 'driver_profile_remote_data_source.dart';

@Injectable(as: DriverProfileRemoteDataSource)
class DriverProfileRemoteDataSourceImpl
    implements DriverProfileRemoteDataSource {
  const DriverProfileRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<DriverUnifiedProfileModelDto> getProfile() async {
    try {
      final response = await _apiServices.getDriverUnifiedProfile();
      return DriverUnifiedProfileModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<DriverUnifiedProfileModelDto> updateDocuments(
    UpdateDriverDocumentsRequestModelDto request,
  ) async {
    try {
      final response = await _apiServices.updateDriverDocumentsProfile(
        request.toJson(),
      );
      return DriverUnifiedProfileModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<void> updateProfilePhoto(String profilePhotoUrl) async {
    try {
      await _apiServices.updateDriverProfilePhoto(<String, dynamic>{
        'profilePhotoUrl': profilePhotoUrl.trim(),
      });
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<void> deleteProfilePhoto() async {
    try {
      await _apiServices.deleteDriverProfilePhoto();
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<DriverUnifiedProfileModelDto> updatePersonal(
    UpdateDriverPersonalRequestModelDto request,
  ) async {
    try {
      final response = await _apiServices.updateDriverPersonalProfile(
        request.toJson(),
      );
      return DriverUnifiedProfileModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<DriverUnifiedProfileModelDto> updateVehicle(
    UpdateDriverVehicleRequestModelDto request,
  ) async {
    try {
      final response = await _apiServices.updateDriverVehicleProfile(
        request.toJson(),
      );
      return DriverUnifiedProfileModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  Map<String, dynamic> _normalizeMap(dynamic response) {
    if (response is Map<String, dynamic>) return response;
    if (response is Map) return Map<String, dynamic>.from(response);
    return const <String, dynamic>{};
  }
}
