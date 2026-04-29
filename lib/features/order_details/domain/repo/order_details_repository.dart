import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_assignment_details_entity.dart';

abstract class OrderDetailsRepository {
  Future<ApiResult<OrderAssignmentDetailsEntity>> getAssignmentDetails(
    String assignmentId,
  );

  Future<ApiResult<void>> markOrderPickedUp(String orderId);

  Future<ApiResult<void>> markOrderOnTheWay(String orderId);

  Future<ApiResult<void>> markOrderDelivered(
    String orderId, {
    Map<String, dynamic>? request,
  });

  Future<ApiResult<void>> markOrderDeliveryFailed(
    String orderId, {
    Map<String, dynamic>? request,
  });

  Future<ApiResult<void>> updateAssignmentStatus(
    String assignmentId, {
    required String newStatus,
  });

  Future<ApiResult<void>> verifyDeliveryOtp(
    String assignmentId, {
    required String otpCode,
  });

  Future<ApiResult<void>> markOrderArrivedAtVendor(String orderId);

  Future<ApiResult<void>> markOrderArrivedAtCustomer(String orderId);
}
