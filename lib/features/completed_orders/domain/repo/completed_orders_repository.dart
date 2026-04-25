import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';

abstract class CompletedOrdersRepository {
  Future<ApiResult<List<CompletedOrder>>> getCompletedOrders({
    CompletedOrderStatus? status,
  });

  Future<ApiResult<CompletedOrderDetails>> getCompletedOrderDetails(
    String orderId,
  );
}
