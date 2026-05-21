import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/models/localized_message.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/driver_support/data/data_source/driver_support_remote_data_source.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_message_request_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_cases_page_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_reason_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/repo/driver_support_repository.dart';

@Injectable(as: DriverSupportRepository)
class DriverSupportRepositoryImpl implements DriverSupportRepository {
  const DriverSupportRepositoryImpl(this._remoteDataSource);

  final DriverSupportRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<DriverSupportCaseEntity>> reportIssue(
    String orderId, {
    required DriverSupportCaseMessageRequestEntity request,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.reportIssue(
        orderId,
        request: request,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<DriverSupportCaseEntity>> createDispute(
    String orderId, {
    required DriverSupportCaseMessageRequestEntity request,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.createDispute(
        orderId,
        request: request,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<DriverSupportCasesPageEntity>> getCases({
    int page = 1,
    int pageSize = 20,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCases(
        page: page,
        pageSize: pageSize,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<DriverSupportCaseEntity>> getCaseDetails(
    String caseId, {
    String? caseType,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCaseDetails(
        caseId,
        caseType: caseType,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<List<DriverSupportReasonEntity>>> getReasons(String type) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getReasons(type);
      return response.map((item) => item.toEntity()).toList(growable: false);
    });
  }

  @override
  Future<ApiResult<DriverSupportCaseEntity>> sendMessage({
    String? orderId,
    required String caseId,
    String? caseType,
    required DriverSupportCaseMessageRequestEntity request,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.sendMessage(
        orderId: orderId,
        caseId: caseId,
        caseType: caseType,
        request: request,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<LocalizedMessage>> createAccountAppeal({
    required DriverSupportCaseMessageRequestEntity request,
  }) {
    return safeApiCall(() async {
      return _remoteDataSource.createAccountAppeal(request: request);
    });
  }

  @override
  Future<ApiResult<LocalizedMessage>> createPublicAccountAppeal({
    required String identifier,
    required DriverSupportCaseMessageRequestEntity request,
  }) {
    return safeApiCall(() async {
      return _remoteDataSource.createPublicAccountAppeal(
        identifier: identifier,
        request: request,
      );
    });
  }
}
