import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_assignment_details_entity.dart';

abstract class OrderDetailsRepository {
  Future<ApiResult<OrderAssignmentDetailsEntity>> getAssignmentDetails(
    String assignmentId,
  );

  Future<ApiResult<OrderAssignmentDetailsEntity?>> markOrderPickedUp(
    String orderId,
  );

  Future<ApiResult<OrderAssignmentDetailsEntity?>> markOrderOnTheWay(
    String orderId,
  );

  Future<ApiResult<OrderAssignmentDetailsEntity?>> markOrderDelivered(
    String orderId, {
    Map<String, dynamic>? request,
  });

  Future<ApiResult<OrderAssignmentDetailsEntity?>> markOrderDeliveryFailed(
    String orderId, {
    Map<String, dynamic>? request,
  });

  Future<ApiResult<OrderAssignmentDetailsEntity?>> updateAssignmentStatus(
    String assignmentId, {
    required String newStatus,
  });

  Future<ApiResult<OrderAssignmentDetailsEntity?>> verifyDeliveryOtp(
    String assignmentId, {
    required String otpCode,
  });

  Future<ApiResult<OrderAssignmentDetailsEntity?>> verifyPickupOtp(
    String assignmentId, {
    required String otpCode,
  });

  Future<ApiResult<OrderAssignmentDetailsEntity?>> markOrderArrivedAtVendor(
    String orderId,
  );

  Future<ApiResult<OrderAssignmentDetailsEntity?>> markOrderArrivedAtCustomer(
    String orderId,
  );
}
