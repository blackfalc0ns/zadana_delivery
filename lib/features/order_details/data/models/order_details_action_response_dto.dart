import 'package:zadana_delivery/features/order_details/data/models/order_assignment_details_model_dto.dart';

class OrderDetailsActionResponseDto {
  const OrderDetailsActionResponseDto({
    this.updatedAssignment,
    this.messageAr,
    this.messageEn,
  });

  factory OrderDetailsActionResponseDto.fromJson(Map<String, dynamic> json) {
    return OrderDetailsActionResponseDto(
      updatedAssignment: _extractUpdatedAssignment(json),
      messageAr: json['messageAr']?.toString(),
      messageEn: json['messageEn']?.toString(),
    );
  }

  final OrderAssignmentDetailsModelDto? updatedAssignment;
  final String? messageAr;
  final String? messageEn;

  static OrderAssignmentDetailsModelDto? _extractUpdatedAssignment(
    Map<String, dynamic> json,
  ) {
    final nested = json['updatedAssignment'];
    if (nested is Map<String, dynamic>) {
      return OrderAssignmentDetailsModelDto.fromJson(nested);
    }
    if (nested is Map) {
      return OrderAssignmentDetailsModelDto.fromJson(
        Map<String, dynamic>.from(nested),
      );
    }
    if (_looksLikeAssignmentPayload(json)) {
      return OrderAssignmentDetailsModelDto.fromJson(json);
    }
    return null;
  }

  static bool _looksLikeAssignmentPayload(Map<String, dynamic> payload) {
    return payload.containsKey('assignmentId') &&
        payload.containsKey('orderId') &&
        payload.containsKey('assignmentStatus');
  }
}
