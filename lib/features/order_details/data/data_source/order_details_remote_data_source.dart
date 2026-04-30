import 'package:zadana_delivery/features/order_details/data/models/order_assignment_details_model_dto.dart';
import 'package:zadana_delivery/features/order_details/data/models/order_details_action_response_dto.dart';

abstract class OrderDetailsRemoteDataSource {
  Future<OrderAssignmentDetailsModelDto> getAssignmentDetails(
    String assignmentId,
  );

  Future<OrderDetailsActionResponseDto> markOrderPickedUp(String orderId);

  Future<OrderDetailsActionResponseDto> markOrderOnTheWay(String orderId);

  Future<OrderDetailsActionResponseDto> markOrderDelivered(
    String orderId, {
    Map<String, dynamic>? request,
  });

  Future<OrderDetailsActionResponseDto> markOrderDeliveryFailed(
    String orderId, {
    Map<String, dynamic>? request,
  });

  Future<OrderDetailsActionResponseDto> updateAssignmentStatus(
    String assignmentId, {
    required String newStatus,
  });

  Future<OrderDetailsActionResponseDto> verifyDeliveryOtp(
    String assignmentId, {
    required String otpCode,
  });

  Future<OrderDetailsActionResponseDto> verifyPickupOtp(
    String assignmentId, {
    required String otpCode,
  });

  Future<OrderDetailsActionResponseDto> markOrderArrivedAtVendor(
    String orderId,
  );

  Future<OrderDetailsActionResponseDto> markOrderArrivedAtCustomer(
    String orderId,
  );
}
