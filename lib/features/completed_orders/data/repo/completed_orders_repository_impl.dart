import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/completed_orders/data/data_source/completed_orders_remote_data_source.dart';
import 'package:zadana_delivery/features/completed_orders/data/mapper/completed_order_mapper.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_orders_page.dart';
import 'package:zadana_delivery/features/completed_orders/domain/repo/completed_orders_repository.dart';

@Injectable(as: CompletedOrdersRepository)
class CompletedOrdersRepositoryImpl implements CompletedOrdersRepository {
  const CompletedOrdersRepositoryImpl(this._remoteDataSource);

  final CompletedOrdersRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<CompletedOrdersPage>> getCompletedOrders({
    CompletedOrderStatus? status,
    int page = 1,
    int perPage = 20,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCompletedOrders(
        status: status,
        page: page,
        perPage: perPage,
      );
      return CompletedOrdersPage(
        orders: response.items
            .map((item) => item.toEntity())
            .toList(growable: false),
        totalCount: response.totalCount,
        page: response.page,
        perPage: response.perPage,
        hasMore: response.hasMore,
      );
    });
  }

  @override
  Future<ApiResult<CompletedOrderDetails>> getCompletedOrderDetails(
    String orderId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getCompletedOrderDetails(
        orderId,
      );
      return response.toEntity();
    });
  }
}
