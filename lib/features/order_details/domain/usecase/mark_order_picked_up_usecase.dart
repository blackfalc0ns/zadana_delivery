import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/order_details/domain/repo/order_details_repository.dart';

class MarkOrderPickedUpUseCase {
  const MarkOrderPickedUpUseCase(this._repository);

  final OrderDetailsRepository _repository;

  Future<ApiResult<void>> call(String orderId) {
    return _repository.markOrderPickedUp(orderId);
  }
}
