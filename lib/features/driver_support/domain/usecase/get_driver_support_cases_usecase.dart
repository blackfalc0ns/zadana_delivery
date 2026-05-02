import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_cases_page_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/repo/driver_support_repository.dart';

class GetDriverSupportCasesUseCase {
  const GetDriverSupportCasesUseCase(this._repository);

  final DriverSupportRepository _repository;

  Future<ApiResult<DriverSupportCasesPageEntity>> call({
    int page = 1,
    int pageSize = 20,
  }) {
    return _repository.getCases(page: page, pageSize: pageSize);
  }
}
