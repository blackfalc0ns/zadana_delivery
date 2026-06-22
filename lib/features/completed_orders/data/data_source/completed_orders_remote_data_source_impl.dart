import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';
import 'package:zadana_delivery/features/completed_orders/data/data_source/completed_orders_remote_data_source.dart';
import 'package:zadana_delivery/features/completed_orders/data/models/completed_order_model_dto.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';

@Injectable(as: CompletedOrdersRemoteDataSource)
class CompletedOrdersRemoteDataSourceImpl
    implements CompletedOrdersRemoteDataSource {
  const CompletedOrdersRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<CompletedOrdersResponseModelDto> getCompletedOrders({
    CompletedOrderStatus? status,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _apiServices.getDriverCompletedOrders(
        status: _statusToApiValue(status),
        page: page,
        perPage: perPage,
      );
      return CompletedOrdersResponseModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<CompletedOrderDetailsModelDto> getCompletedOrderDetails(
    String orderId,
  ) async {
    try {
      final response = await _apiServices.getDriverCompletedOrderDetails(
        orderId,
      );
      return CompletedOrderDetailsModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  Map<String, dynamic> _normalizeMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }

  String? _statusToApiValue(CompletedOrderStatus? status) {
    switch (status) {
      case CompletedOrderStatus.delivered:
        return 'delivered';
      case CompletedOrderStatus.cancelled:
        return 'cancelled';
      case CompletedOrderStatus.deliveryFailed:
        return 'deliveryFailed';
      case null:
        return null;
    }
  }
}
