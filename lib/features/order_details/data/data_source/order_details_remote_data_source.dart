import 'package:zadana_delivery/features/order_details/data/models/order_assignment_details_model_dto.dart';

abstract class OrderDetailsRemoteDataSource {
  Future<OrderAssignmentDetailsModelDto> getAssignmentDetails(
    String assignmentId,
  );
}
