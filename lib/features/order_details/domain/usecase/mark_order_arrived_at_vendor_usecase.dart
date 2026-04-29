import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/order_details/domain/repo/order_details_repository.dart';

class MarkOrderArrivedAtVendorUseCase {
  const MarkOrderArrivedAtVendorUseCase(this._repository);

  final OrderDetailsRepository _repository;

  Future<ApiResult<void>> call(String orderId) {
    return _repository.markOrderArrivedAtVendor(orderId);
  }
}
