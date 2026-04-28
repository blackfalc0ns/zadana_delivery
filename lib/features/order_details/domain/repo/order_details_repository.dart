import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_assignment_details_entity.dart';

abstract class OrderDetailsRepository {
  Future<ApiResult<OrderAssignmentDetailsEntity>> getAssignmentDetails(
    String assignmentId,
  );
}
