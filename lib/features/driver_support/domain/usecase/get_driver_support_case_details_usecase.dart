import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/repo/driver_support_repository.dart';

class GetDriverSupportCaseDetailsUseCase {
  const GetDriverSupportCaseDetailsUseCase(this._repository);

  final DriverSupportRepository _repository;

  Future<ApiResult<DriverSupportCaseEntity>> call(String caseId) {
    return _repository.getCaseDetails(caseId);
  }
}
