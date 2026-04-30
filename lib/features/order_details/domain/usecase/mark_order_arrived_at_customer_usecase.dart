import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_assignment_details_entity.dart';
import 'package:zadana_delivery/features/order_details/domain/repo/order_details_repository.dart';

class MarkOrderArrivedAtCustomerUseCase {
  const MarkOrderArrivedAtCustomerUseCase(this._repository);

  final OrderDetailsRepository _repository;

  Future<ApiResult<OrderAssignmentDetailsEntity?>> call(String orderId) {
    return _repository.markOrderArrivedAtCustomer(orderId);
  }
}
