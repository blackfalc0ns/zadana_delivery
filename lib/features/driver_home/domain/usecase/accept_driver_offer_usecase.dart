import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/driver_home/domain/repo/driver_home_repository.dart';

@injectable
class AcceptDriverOfferUseCase {
  const AcceptDriverOfferUseCase(this._repository);

  final DriverHomeRepository _repository;

  Future<ApiResult<void>> call(String assignmentId) {
    return _repository.acceptOffer(assignmentId);
  }
}
