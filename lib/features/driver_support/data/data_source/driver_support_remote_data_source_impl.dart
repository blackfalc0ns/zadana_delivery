import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/models/localized_message.dart';
import 'package:zadana_delivery/core/network/api_services.dart';
import 'package:zadana_delivery/core/network/network_constants.dart';
import 'package:zadana_delivery/core/services/token_interceptor.dart';
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
  Dio get _dio => getIt<Dio>();

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
      final responses = await Future.wait<Response<dynamic>>([
        _dio.get<dynamic>(
          EndPoints.driverSupportCases,
          queryParameters: <String, dynamic>{
            'page': page,
            'pageSize': pageSize,
          },
        ),
        _dio.get<dynamic>(
          EndPoints.driverSupportAccountCases,
          queryParameters: <String, dynamic>{
            'page': page,
            'pageSize': pageSize,
          },
        ),
      ]);

      final orderCasesPage = DriverSupportCasesPageModelDto.fromJson(
        _normalizeMap(responses[0].data),
      );
      final accountCasesPage = DriverSupportCasesPageModelDto.fromJson(
        _normalizeMap(responses[1].data),
      );
      final mergedItems = <DriverSupportCaseModelDto>[
        ...orderCasesPage.items,
        ...accountCasesPage.items,
      ]..sort(_compareCaseModels);

      return DriverSupportCasesPageModelDto(
        items: mergedItems.take(pageSize).toList(growable: false),
        page: page,
        pageSize: pageSize,
        total: orderCasesPage.total + accountCasesPage.total,
        hasMore:
            orderCasesPage.hasMore ||
            accountCasesPage.hasMore ||
            mergedItems.length > pageSize,
      );
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<DriverSupportCaseModelDto> getCaseDetails(
    String caseId, {
    String? caseType,
  }) async {
    if (_isAccountCaseType(caseType)) {
      return _getAccountCaseDetails(caseId);
    }

    try {
      final response = await _apiServices.getDriverSupportCaseDetails(caseId);
      return DriverSupportCaseModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      if (_shouldFallbackToAccountCase(exception, caseType: caseType)) {
        return _getAccountCaseDetails(caseId);
      }
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
    String? orderId,
    required String caseId,
    String? caseType,
    required DriverSupportCaseMessageRequestEntity request,
  }) async {
    if (_isAccountCaseType(caseType)) {
      return _sendAccountCaseMessage(caseId: caseId, request: request);
    }

    final normalizedOrderId = (orderId ?? '').trim();
    if (normalizedOrderId.isEmpty) {
      return _sendAccountCaseMessage(caseId: caseId, request: request);
    }

    try {
      final response = await _apiServices.sendDriverSupportCaseMessage(
        normalizedOrderId,
        caseId,
        _requestToJson(request),
      );
      return DriverSupportCaseModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      if (_shouldFallbackToAccountCase(exception, caseType: caseType)) {
        return _sendAccountCaseMessage(caseId: caseId, request: request);
      }
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<LocalizedMessage> createAccountAppeal({
    required DriverSupportCaseMessageRequestEntity request,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        EndPoints.driverSupportAccountAppeals,
        data: _requestToJson(request),
      );
      return LocalizedMessage.fromJson(_normalizeMap(response.data));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<LocalizedMessage> createPublicAccountAppeal({
    required String identifier,
    required DriverSupportCaseMessageRequestEntity request,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        EndPoints.driverAccountSupportAppeals,
        data: <String, dynamic>{
          'identifier': identifier.trim(),
          ..._requestToJson(request),
        },
        options: Options(
          extra: <String, dynamic>{TokenInterceptor.skipAuthKey: true},
        ),
      );
      return LocalizedMessage.fromJson(_normalizeMap(response.data));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  Future<DriverSupportCaseModelDto> _getAccountCaseDetails(
    String caseId,
  ) async {
    try {
      final response = await _dio.get<dynamic>(
        EndPoints.driverSupportAccountCaseDetails.replaceFirst(
          '{caseId}',
          caseId,
        ),
      );
      return DriverSupportCaseModelDto.fromJson(_normalizeMap(response.data));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  Future<DriverSupportCaseModelDto> _sendAccountCaseMessage({
    required String caseId,
    required DriverSupportCaseMessageRequestEntity request,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        EndPoints.driverSupportAccountCaseMessages.replaceFirst(
          '{caseId}',
          caseId,
        ),
        data: _requestToJson(request),
      );
      return DriverSupportCaseModelDto.fromJson(_normalizeMap(response.data));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  bool _isAccountCaseType(String? caseType) {
    return (caseType ?? '').trim().toLowerCase() == 'driver_account';
  }

  bool _shouldFallbackToAccountCase(
    DioException exception, {
    String? caseType,
  }) {
    return !_isAccountCaseType(caseType) &&
        exception.response?.statusCode == 404;
  }

  int _compareCaseModels(
    DriverSupportCaseModelDto left,
    DriverSupportCaseModelDto right,
  ) {
    final leftDate =
        left.updatedAt ?? left.createdAt ?? left.closedAt ?? DateTime(1970);
    final rightDate =
        right.updatedAt ?? right.createdAt ?? right.closedAt ?? DateTime(1970);
    return rightDate.compareTo(leftDate);
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
