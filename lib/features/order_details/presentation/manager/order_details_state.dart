import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_assignment_details_entity.dart';

class OrderDetailsState {
  const OrderDetailsState({this.isLoading = false, this.details, this.failure});

  final bool isLoading;
  final OrderAssignmentDetailsEntity? details;
  final Failure? failure;

  OrderDetailsState copyWith({
    bool? isLoading,
    OrderAssignmentDetailsEntity? details,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return OrderDetailsState(
      isLoading: isLoading ?? this.isLoading,
      details: details ?? this.details,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}
