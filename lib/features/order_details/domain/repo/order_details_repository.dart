import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_assignment_details_entity.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_details_action_result_entity.dart';

abstract class OrderDetailsRepository {
  Future<ApiResult<OrderAssignmentDetailsEntity>> getAssignmentDetails(
    String assignmentId,
  );

  Future<ApiResult<OrderDetailsActionResultEntity>> markOrderPickedUp(
    String orderId,
  );

  Future<ApiResult<OrderDetailsActionResultEntity>> markOrderOnTheWay(
    String orderId,
  );

  Future<ApiResult<OrderDetailsActionResultEntity>> markOrderDelivered(
    String orderId, {
    Map<String, dynamic>? request,
  });

  Future<ApiResult<OrderDetailsActionResultEntity>> markOrderDeliveryFailed(
    String orderId, {
    Map<String, dynamic>? request,
  });

  Future<ApiResult<OrderDetailsActionResultEntity>> updateAssignmentStatus(
    String assignmentId, {
    required String newStatus,
  });

  Future<ApiResult<OrderDetailsActionResultEntity>> verifyDeliveryOtp(
    String assignmentId, {
    required String otpCode,
  });

  Future<ApiResult<OrderDetailsActionResultEntity>> verifyPickupOtp(
    String assignmentId, {
    required String otpCode,
  });

  Future<ApiResult<OrderDetailsActionResultEntity>> markOrderArrivedAtVendor(
    String orderId,
  );

  Future<ApiResult<OrderDetailsActionResultEntity>> markOrderArrivedAtCustomer(
    String orderId,
  );
}
