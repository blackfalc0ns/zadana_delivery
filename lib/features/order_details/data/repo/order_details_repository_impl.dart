import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/order_details/data/data_source/order_details_remote_data_source.dart';
import 'package:zadana_delivery/features/order_details/data/mapper/order_assignment_details_mapper.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_assignment_details_entity.dart';
import 'package:zadana_delivery/features/order_details/domain/repo/order_details_repository.dart';

@Injectable(as: OrderDetailsRepository)
class OrderDetailsRepositoryImpl implements OrderDetailsRepository {
  const OrderDetailsRepositoryImpl(this._remoteDataSource);

  final OrderDetailsRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<OrderAssignmentDetailsEntity>> getAssignmentDetails(
    String assignmentId,
  ) {
    return safeApiCall(() async {
      final details = await _remoteDataSource.getAssignmentDetails(
        assignmentId,
      );
      return details.toEntity();
    });
  }

  @override
  Future<ApiResult<void>> markOrderPickedUp(String orderId) {
    return safeApiCall(() async {
      await _remoteDataSource.markOrderPickedUp(orderId);
    });
  }

  @override
  Future<ApiResult<void>> markOrderOnTheWay(String orderId) {
    return safeApiCall(() async {
      await _remoteDataSource.markOrderOnTheWay(orderId);
    });
  }

  @override
  Future<ApiResult<void>> markOrderDelivered(
    String orderId, {
    Map<String, dynamic>? request,
  }) {
    return safeApiCall(() async {
      await _remoteDataSource.markOrderDelivered(orderId, request: request);
    });
  }

  @override
  Future<ApiResult<void>> markOrderDeliveryFailed(
    String orderId, {
    Map<String, dynamic>? request,
  }) {
    return safeApiCall(() async {
      await _remoteDataSource.markOrderDeliveryFailed(
        orderId,
        request: request,
      );
    });
  }

  @override
  Future<ApiResult<void>> updateAssignmentStatus(
    String assignmentId, {
    required String newStatus,
  }) {
    return safeApiCall(() async {
      await _remoteDataSource.updateAssignmentStatus(
        assignmentId,
        newStatus: newStatus,
      );
    });
  }

  @override
  Future<ApiResult<void>> verifyDeliveryOtp(
    String assignmentId, {
    required String otpCode,
  }) {
    return safeApiCall(() async {
      await _remoteDataSource.verifyDeliveryOtp(assignmentId, otpCode: otpCode);
    });
  }

  @override
  Future<ApiResult<void>> markOrderArrivedAtVendor(String orderId) {
    return safeApiCall(() async {
      await _remoteDataSource.markOrderArrivedAtVendor(orderId);
    });
  }

  @override
  Future<ApiResult<void>> markOrderArrivedAtCustomer(String orderId) {
    return safeApiCall(() async {
      await _remoteDataSource.markOrderArrivedAtCustomer(orderId);
    });
  }
}
