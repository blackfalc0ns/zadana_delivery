import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_message_request_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_cases_page_entity.dart';

abstract class DriverSupportRepository {
  Future<ApiResult<DriverSupportCaseEntity>> reportIssue(
    String orderId, {
    required DriverSupportCaseMessageRequestEntity request,
  });

  Future<ApiResult<DriverSupportCaseEntity>> createDispute(
    String orderId, {
    required DriverSupportCaseMessageRequestEntity request,
  });

  Future<ApiResult<DriverSupportCasesPageEntity>> getCases({
    int page = 1,
    int pageSize = 20,
  });

  Future<ApiResult<DriverSupportCaseEntity>> getCaseDetails(String caseId);

  Future<ApiResult<DriverSupportCaseEntity>> sendMessage({
    required String orderId,
    required String caseId,
    required DriverSupportCaseMessageRequestEntity request,
  });
}
