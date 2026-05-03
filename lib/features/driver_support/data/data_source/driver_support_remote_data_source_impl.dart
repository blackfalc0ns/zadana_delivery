import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';
import 'package:zadana_delivery/features/driver_support/data/data_source/driver_support_remote_data_source.dart';
import 'package:zadana_delivery/features/driver_support/data/models/driver_support_attachment_dto.dart';
import 'package:zadana_delivery/features/driver_support/data/models/driver_support_case_model_dto.dart';
import 'package:zadana_delivery/features/driver_support/data/models/driver_support_cases_page_model_dto.dart';
import 'package:zadana_delivery/features/driver_support/data/models/driver_support_reason_dto.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_message_request_entity.dart';

@Injectable(as: DriverSupportRemoteDataSource)
class DriverSupportRemoteDataSourceImpl
    implements DriverSupportRemoteDataSource {
  const DriverSupportRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<DriverSupportCaseModelDto> reportIssue(
    String orderId, {
    required DriverSupportCaseMessageRequestEntity request,
  }) async {
    try {
      final response = await _apiServices.reportDriverOrderIssue(
        orderId,
        _requestToJson(request),
      );
      return DriverSupportCaseModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<DriverSupportCaseModelDto> createDispute(
    String orderId, {
    required DriverSupportCaseMessageRequestEntity request,
  }) async {
    try {
      final response = await _apiServices.createDriverOrderDispute(
        orderId,
        _requestToJson(request),
      );
      return DriverSupportCaseModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<DriverSupportCasesPageModelDto> getCases({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiServices.getDriverSupportCases(
        page: page,
        pageSize: pageSize,
      );
      return DriverSupportCasesPageModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<DriverSupportCaseModelDto> getCaseDetails(String caseId) async {
    try {
      final response = await _apiServices.getDriverSupportCaseDetails(caseId);
      return DriverSupportCaseModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<List<DriverSupportReasonDto>> getReasons(String type) async {
    try {
      final response = await _apiServices.getDriverSupportReasons(type);
      if (response is! List) return const <DriverSupportReasonDto>[];
      return response
          .map((item) => DriverSupportReasonDto.fromJson(_normalizeMap(item)))
          .toList(growable: false);
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<DriverSupportCaseModelDto> sendMessage({
    required String orderId,
    required String caseId,
    required DriverSupportCaseMessageRequestEntity request,
  }) async {
    try {
      final response = await _apiServices.sendDriverSupportCaseMessage(
        orderId,
        caseId,
        _requestToJson(request),
      );
      return DriverSupportCaseModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  Map<String, dynamic> _requestToJson(
    DriverSupportCaseMessageRequestEntity request,
  ) {
    return <String, dynamic>{
      'reason_code': request.reasonCode,
      'message': request.message,
      'attachments': request.attachments
          .map(
            (item) => DriverSupportAttachmentDto(
              fileName: item.fileName,
              fileUrl: item.fileUrl,
            ).toJson(),
          )
          .toList(growable: false),
    };
  }

  Map<String, dynamic> _normalizeMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }
}
