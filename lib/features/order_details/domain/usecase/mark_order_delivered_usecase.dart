import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_details_action_result_entity.dart';
import 'package:zadana_delivery/features/order_details/domain/repo/order_details_repository.dart';

class MarkOrderDeliveredUseCase {
  const MarkOrderDeliveredUseCase(this._repository);

  final OrderDetailsRepository _repository;

  Future<ApiResult<OrderDetailsActionResultEntity>> call(
    String orderId, {
    Map<String, dynamic>? request,
  }) {
    return _repository.markOrderDelivered(orderId, request: request);
  }
}
