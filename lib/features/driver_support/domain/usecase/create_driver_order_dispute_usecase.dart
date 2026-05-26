import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_message_request_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/repo/driver_support_repository.dart';

@injectable
class CreateDriverOrderDisputeUseCase {
  const CreateDriverOrderDisputeUseCase(this._repository);

  final DriverSupportRepository _repository;

  Future<ApiResult<DriverSupportCaseEntity>> call(
    String orderId, {
    required DriverSupportCaseMessageRequestEntity request,
  }) {
    return _repository.createDispute(orderId, request: request);
  }
}
