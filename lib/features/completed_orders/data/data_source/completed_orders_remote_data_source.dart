import 'package:zadana_delivery/features/completed_orders/data/models/completed_order_model_dto.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';

abstract class CompletedOrdersRemoteDataSource {
  Future<CompletedOrdersResponseModelDto> getCompletedOrders({
    CompletedOrderStatus? status,
  });

  Future<CompletedOrderDetailsModelDto> getCompletedOrderDetails(
    String orderId,
  );
}
