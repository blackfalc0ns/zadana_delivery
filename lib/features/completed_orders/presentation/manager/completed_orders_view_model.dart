import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';
import 'package:zadana_delivery/features/completed_orders/domain/usecase/get_completed_order_details_usecase.dart';
import 'package:zadana_delivery/features/completed_orders/domain/usecase/get_completed_orders_usecase.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/manager/completed_orders_event.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/manager/completed_orders_state.dart';

@injectable
class CompletedOrdersViewModel extends Cubit<CompletedOrdersState> {
  CompletedOrdersViewModel(
    this._getCompletedOrdersUseCase,
    this._getCompletedOrderDetailsUseCase,
  ) : super(const CompletedOrdersState());

  final GetCompletedOrdersUseCase _getCompletedOrdersUseCase;
  final GetCompletedOrderDetailsUseCase _getCompletedOrderDetailsUseCase;

  void loadInitial() {
    doIntent(const CompletedOrdersLoadEvent());
  }

  Future<void> selectStatus(CompletedOrderStatus status) {
    return doIntent(CompletedOrdersSelectStatusEvent(status));
  }

  Future<void> refreshOrders() {
    return doIntent(const CompletedOrdersLoadEvent(refresh: true));
  }

  void clearError() {
    doIntent(const CompletedOrdersClearErrorEvent());
  }

  Future<CompletedOrderDetails?> loadOrderDetails(String orderId) {
    return doIntent(CompletedOrdersLoadDetailsEvent(orderId));
  }

  bool get showGlobalError =>
      !state.isLoading &&
      !state.isFilterLoading &&
      !state.isRefreshing &&
      !state.isDetailsLoading &&
      state.failure != null &&
      state.orders.isEmpty;

  bool get showSkeleton => state.isLoading || state.isFilterLoading;

  double get totalDistance =>
      state.orders.fold<double>(0, (sum, order) => sum + order.distanceKm);

  bool isDetailsLoadingFor(String orderId) {
    return state.isDetailsLoading && state.activeDetailsOrderId == orderId;
  }

  CompletedOrder? findOrderById(String orderId) {
    return _orderById(orderId);
  }

  Future<void> retryCurrentRequest() async {
    if (state.lastDetailsOrderId != null && !showGlobalError) {
      await _loadOrderDetails(state.lastDetailsOrderId!);
      return;
    }

    await _loadOrders(refresh: state.hasLoadedOnce);
  }

  Future<CompletedOrderDetails?> doIntent(CompletedOrdersEvent event) async {
    switch (event) {
      case CompletedOrdersLoadEvent():
        await _loadOrders(refresh: event.refresh);
        return null;
      case CompletedOrdersSelectStatusEvent():
        await _selectStatus(event.status);
        return null;
      case CompletedOrdersClearErrorEvent():
        _clearError();
        return null;
      case CompletedOrdersLoadDetailsEvent():
        return _loadOrderDetails(event.orderId);
    }
  }

  Future<void> _selectStatus(CompletedOrderStatus status) async {
    emit(state.copyWith(selectedStatus: status, clearFailure: true));
    await _loadOrders();
  }

  Future<void> _loadOrders({bool refresh = false}) async {
    final isInitialLoad = !refresh && !state.hasLoadedOnce;
    final isFilterLoad = !refresh && state.hasLoadedOnce;

    emit(
      state.copyWith(
        isLoading: isInitialLoad,
        isFilterLoading: isFilterLoad,
        isRefreshing: refresh,
        clearFailure: true,
      ),
    );

    final result = await _getCompletedOrdersUseCase.call(
      status: state.selectedStatus,
    );

    switch (result) {
      case ApiSuccessResult():
        final orders = result.data
          ..sort(
            (first, second) => second.completedAt.compareTo(first.completedAt),
          );
        emit(
          state.copyWith(
            isLoading: false,
            isFilterLoading: false,
            isRefreshing: false,
            hasLoadedOnce: true,
            orders: orders,
            totalCount: orders.length,
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoading: false,
            isFilterLoading: false,
            isRefreshing: false,
            failure: result.failure,
          ),
        );
    }
  }

  Future<CompletedOrderDetails?> _loadOrderDetails(String orderId) async {
    emit(
      state.copyWith(
        isDetailsLoading: true,
        activeDetailsOrderId: orderId,
        lastDetailsOrderId: orderId,
        clearFailure: true,
      ),
    );

    final result = await _getCompletedOrderDetailsUseCase.call(orderId);
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isDetailsLoading: false,
            clearActiveDetailsOrderId: true,
            lastDetailsOrderId: orderId,
            clearFailure: true,
          ),
        );
        return result.data;
      case ApiErrorResult():
        emit(
          state.copyWith(
            isDetailsLoading: false,
            clearActiveDetailsOrderId: true,
            lastDetailsOrderId: orderId,
            failure: result.failure,
          ),
        );
        return null;
    }
  }

  void _clearError() {
    if (state.failure == null) return;
    emit(state.copyWith(clearFailure: true));
  }

  CompletedOrder? _orderById(String orderId) {
    for (final order in state.orders) {
      if (order.id == orderId) return order;
    }
    return null;
  }
}
