import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_orders_page.dart';

abstract class CompletedOrdersRepository {
  Future<ApiResult<CompletedOrdersPage>> getCompletedOrders({
    CompletedOrderStatus? status,
    int page = 1,
    int perPage = 20,
  });

  Future<ApiResult<CompletedOrderDetails>> getCompletedOrderDetails(
    String orderId,
  );
}
