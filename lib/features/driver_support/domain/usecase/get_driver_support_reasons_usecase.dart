import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_reason_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/repo/driver_support_repository.dart';

@injectable
class GetDriverSupportReasonsUseCase {
  const GetDriverSupportReasonsUseCase(this._repository);

  final DriverSupportRepository _repository;

  Future<ApiResult<List<DriverSupportReasonEntity>>> call(String type) {
    return _repository.getReasons(type);
  }
}
