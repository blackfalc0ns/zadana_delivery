import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_assignment_details_entity.dart';

class OrderDetailsState {
  const OrderDetailsState({
    this.isLoading = false,
    this.isActionLoading = false,
    this.details,
    this.failure,
    this.notificationMessage,
  });

  final bool isLoading;
  final bool isActionLoading;
  final OrderAssignmentDetailsEntity? details;
  final Failure? failure;
  final String? notificationMessage;

  OrderDetailsState copyWith({
    bool? isLoading,
    bool? isActionLoading,
    OrderAssignmentDetailsEntity? details,
    Failure? failure,
    String? notificationMessage,
    bool clearFailure = false,
    bool clearNotificationMessage = false,
  }) {
    return OrderDetailsState(
      isLoading: isLoading ?? this.isLoading,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      details: details ?? this.details,
      failure: clearFailure ? null : failure ?? this.failure,
      notificationMessage: clearNotificationMessage
          ? null
          : notificationMessage ?? this.notificationMessage,
    );
  }
}
