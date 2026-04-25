import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';
import 'package:zadana_delivery/features/completed_orders/domain/repo/completed_orders_repository.dart';

@injectable
class GetCompletedOrderDetailsUseCase {
  const GetCompletedOrderDetailsUseCase(this._repository);

  final CompletedOrdersRepository _repository;

  Future<ApiResult<CompletedOrderDetails>> call(String orderId) {
    return _repository.getCompletedOrderDetails(orderId);
  }
}
