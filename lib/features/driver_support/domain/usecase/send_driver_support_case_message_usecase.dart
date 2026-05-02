import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_message_request_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/repo/driver_support_repository.dart';

class SendDriverSupportCaseMessageUseCase {
  const SendDriverSupportCaseMessageUseCase(this._repository);

  final DriverSupportRepository _repository;

  Future<ApiResult<DriverSupportCaseEntity>> call({
    required String orderId,
    required String caseId,
    required DriverSupportCaseMessageRequestEntity request,
  }) {
    return _repository.sendMessage(
      orderId: orderId,
      caseId: caseId,
      request: request,
    );
  }
}
