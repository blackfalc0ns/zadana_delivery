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

  static const int _perPage = 20;

  /// Cache per status tab to avoid re-fetching when switching.
  final Map<CompletedOrderStatus, _TabCache> _cache = {};


  void loadInitial() {
    doIntent(const CompletedOrdersLoadEvent());
  }

  Future<void> selectStatus(CompletedOrderStatus status) {
    return doIntent(CompletedOrdersSelectStatusEvent(status));
  }

  Future<void> refreshOrders() {
    return doIntent(const CompletedOrdersLoadEvent(refresh: true));
  }

  Future<void> loadMore() {
    return doIntent(const CompletedOrdersLoadMoreEvent());
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
      case CompletedOrdersLoadMoreEvent():
        await _loadMoreOrders();
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
    if (status == state.selectedStatus) return;

    // Save current tab data to cache before switching.
    _saveCurrentToCache();

    emit(state.copyWith(selectedStatus: status, clearFailure: true));

    // Restore from cache if available.
    final cached = _cache[status];
    if (cached != null) {
      emit(
        state.copyWith(
          isLoading: false,
          isFilterLoading: false,
          isRefreshing: false,
          hasLoadedOnce: true,
          orders: cached.orders,
          totalCount: cached.totalCount,
          currentPage: cached.currentPage,
          hasMore: cached.hasMore,
          clearFailure: true,
        ),
      );
      return;
    }

    await _loadOrders();
  }

  Future<void> _loadOrders({bool refresh = false}) async {
    final isInitialLoad = !refresh && !state.hasLoadedOnce;
    final isFilterLoad = !refresh && state.hasLoadedOnce;

    // If refreshing, invalidate cache for current status.
    if (refresh) {
      _cache.remove(state.selectedStatus);
    }

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
      page: 1,
      perPage: _perPage,
    );

    switch (result) {
      case ApiSuccessResult():
        final page = result.data;
        final orders = page.orders
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
            totalCount: page.totalCount,
            currentPage: page.page,
            hasMore: page.hasMore,
            clearFailure: true,
          ),
        );
        _saveCurrentToCache();
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

  Future<void> _loadMoreOrders() async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true, clearFailure: true));

    final nextPage = state.currentPage + 1;
    final result = await _getCompletedOrdersUseCase.call(
      status: state.selectedStatus,
      page: nextPage,
      perPage: _perPage,
    );

    switch (result) {
      case ApiSuccessResult():
        final page = result.data;
        final allOrders = [...state.orders, ...page.orders]
          ..sort(
            (first, second) => second.completedAt.compareTo(first.completedAt),
          );
        emit(
          state.copyWith(
            isLoadingMore: false,
            orders: allOrders,
            totalCount: page.totalCount,
            currentPage: page.page,
            hasMore: page.hasMore,
            clearFailure: true,
          ),
        );
        _saveCurrentToCache();
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoadingMore: false,
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
            clearFailure: true,
          ),
        );
        return result.data;
      case ApiErrorResult():
        emit(
          state.copyWith(
            isDetailsLoading: false,
            clearActiveDetailsOrderId: true,
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

  void _saveCurrentToCache() {
    _cache[state.selectedStatus] = _TabCache(
      orders: state.orders,
      totalCount: state.totalCount,
      currentPage: state.currentPage,
      hasMore: state.hasMore,
    );
  }

  CompletedOrder? _orderById(String orderId) {
    try {
      return state.orders.firstWhere((order) => order.id == orderId);
    } catch (_) {
      return null;
    }
  }
}

class _TabCache {
  const _TabCache({
    required this.orders,
    required this.totalCount,
    required this.currentPage,
    required this.hasMore,
  });

  final List<CompletedOrder> orders;
  final int totalCount;
  final int currentPage;
  final bool hasMore;
}
