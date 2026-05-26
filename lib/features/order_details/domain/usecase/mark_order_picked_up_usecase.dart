import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_details_action_result_entity.dart';
import 'package:zadana_delivery/features/order_details/domain/repo/order_details_repository.dart';

@injectable
class MarkOrderPickedUpUseCase {
  const MarkOrderPickedUpUseCase(this._repository);

  final OrderDetailsRepository _repository;

  Future<ApiResult<OrderDetailsActionResultEntity>> call(String orderId) {
    return _repository.markOrderPickedUp(orderId);
  }
}
