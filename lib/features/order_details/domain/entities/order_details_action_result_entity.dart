import 'package:zadana_delivery/core/models/localized_message.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_assignment_details_entity.dart';

class OrderDetailsActionResultEntity {
  const OrderDetailsActionResultEntity({
    this.updatedAssignment,
    this.localizedMessage,
    this.status,
    this.oldStatus,
    this.newStatus,
    this.arrivalState,
  });

  final OrderAssignmentDetailsEntity? updatedAssignment;
  final LocalizedMessage? localizedMessage;
  final String? status;
  final String? oldStatus;
  final String? newStatus;
  final String? arrivalState;
}
