import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_orders_page.dart';
import 'package:zadana_delivery/features/completed_orders/domain/repo/completed_orders_repository.dart';

@injectable
class GetCompletedOrdersUseCase {
  const GetCompletedOrdersUseCase(this._repository);

  final CompletedOrdersRepository _repository;

  Future<ApiResult<CompletedOrdersPage>> call({
    CompletedOrderStatus? status,
    int page = 1,
    int perPage = 20,
  }) {
    return _repository.getCompletedOrders(
      status: status,
      page: page,
      perPage: perPage,
    );
  }
}
