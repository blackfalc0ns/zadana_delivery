import 'package:zadana_delivery/features/driver_support/data/models/driver_support_case_model_dto.dart';
import 'package:zadana_delivery/features/driver_support/data/models/driver_support_cases_page_model_dto.dart';
import 'package:zadana_delivery/features/driver_support/data/models/driver_support_reason_dto.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_message_request_entity.dart';

abstract class DriverSupportRemoteDataSource {
  Future<DriverSupportCaseModelDto> reportIssue(
    String orderId, {
    required DriverSupportCaseMessageRequestEntity request,
  });

  Future<DriverSupportCaseModelDto> createDispute(
    String orderId, {
    required DriverSupportCaseMessageRequestEntity request,
  });

  Future<DriverSupportCasesPageModelDto> getCases({
    int page = 1,
    int pageSize = 20,
  });

  Future<DriverSupportCaseModelDto> getCaseDetails(String caseId);

  Future<List<DriverSupportReasonDto>> getReasons(String type);

  Future<DriverSupportCaseModelDto> sendMessage({
    required String orderId,
    required String caseId,
    required DriverSupportCaseMessageRequestEntity request,
  });
}
