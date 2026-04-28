import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/get_order_assignment_details_usecase.dart';
import 'package:zadana_delivery/features/order_details/presentation/manager/order_details_event.dart';
import 'package:zadana_delivery/features/order_details/presentation/manager/order_details_state.dart';

@injectable
class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  OrderDetailsCubit(this._getOrderAssignmentDetailsUseCase)
    : super(const OrderDetailsState());

  final GetOrderAssignmentDetailsUseCase _getOrderAssignmentDetailsUseCase;

  Future<void> doIntent(OrderDetailsEvent event) async {
    switch (event) {
      case OrderDetailsLoadAssignmentEvent():
        await _loadAssignmentDetails(event.assignmentId);
      case OrderDetailsClearErrorEvent():
        clearError();
    }
  }

  Future<void> _loadAssignmentDetails(String assignmentId) async {
    emit(state.copyWith(isLoading: true, clearFailure: true));

    final result = await _getOrderAssignmentDetailsUseCase.call(assignmentId);
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            details: result.data,
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(state.copyWith(isLoading: false, failure: result.failure));
    }
  }

  void clearError() {
    if (state.failure == null) return;
    emit(state.copyWith(clearFailure: true));
  }
}
