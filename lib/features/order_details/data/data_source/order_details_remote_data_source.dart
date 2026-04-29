import 'package:zadana_delivery/features/order_details/data/models/order_assignment_details_model_dto.dart';

abstract class OrderDetailsRemoteDataSource {
  Future<OrderAssignmentDetailsModelDto> getAssignmentDetails(
    String assignmentId,
  );

  Future<void> markOrderPickedUp(String orderId);

  Future<void> markOrderOnTheWay(String orderId);

  Future<void> markOrderDelivered(
    String orderId, {
    Map<String, dynamic>? request,
  });

  Future<void> markOrderDeliveryFailed(
    String orderId, {
    Map<String, dynamic>? request,
  });

  Future<void> updateAssignmentStatus(
    String assignmentId, {
    required String newStatus,
  });

  Future<void> verifyDeliveryOtp(
    String assignmentId, {
    required String otpCode,
  });

  Future<void> markOrderArrivedAtVendor(String orderId);

  Future<void> markOrderArrivedAtCustomer(String orderId);
}
