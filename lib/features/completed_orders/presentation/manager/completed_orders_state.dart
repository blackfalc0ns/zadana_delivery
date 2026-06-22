import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';

class CompletedOrdersState {
  const CompletedOrdersState({
    this.isLoading = false,
    this.isFilterLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.isDetailsLoading = false,
    this.hasLoadedOnce = false,
    this.activeDetailsOrderId,
    this.lastDetailsOrderId,
    this.selectedStatus = CompletedOrderStatus.delivered,
    this.orders = const <CompletedOrder>[],
    this.totalCount = 0,
    this.currentPage = 1,
    this.hasMore = false,
    this.failure,
  });

  final bool isLoading;
  final bool isFilterLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool isDetailsLoading;
  final bool hasLoadedOnce;
  final String? activeDetailsOrderId;
  final String? lastDetailsOrderId;
  final CompletedOrderStatus selectedStatus;
  final List<CompletedOrder> orders;
  final int totalCount;
  final int currentPage;
  final bool hasMore;
  final Failure? failure;

  CompletedOrdersState copyWith({
    bool? isLoading,
    bool? isFilterLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? isDetailsLoading,
    bool? hasLoadedOnce,
    String? activeDetailsOrderId,
    String? lastDetailsOrderId,
    CompletedOrderStatus? selectedStatus,
    List<CompletedOrder>? orders,
    int? totalCount,
    int? currentPage,
    bool? hasMore,
    Failure? failure,
    bool clearFailure = false,
    bool clearActiveDetailsOrderId = false,
  }) {
    return CompletedOrdersState(
      isLoading: isLoading ?? this.isLoading,
      isFilterLoading: isFilterLoading ?? this.isFilterLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isDetailsLoading: isDetailsLoading ?? this.isDetailsLoading,
      hasLoadedOnce: hasLoadedOnce ?? this.hasLoadedOnce,
      activeDetailsOrderId: clearActiveDetailsOrderId
          ? null
          : activeDetailsOrderId ?? this.activeDetailsOrderId,
      lastDetailsOrderId: lastDetailsOrderId ?? this.lastDetailsOrderId,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      orders: orders ?? this.orders,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}
