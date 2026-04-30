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
  Future<ApiResult<OrderAssignmentDetailsEntity?>> markOrderPickedUp(
    String orderId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.markOrderPickedUp(orderId);
      return response.updatedAssignment?.toEntity();
    });
  }

  @override
  Future<ApiResult<OrderAssignmentDetailsEntity?>> markOrderOnTheWay(
    String orderId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.markOrderOnTheWay(orderId);
      return response.updatedAssignment?.toEntity();
    });
  }

  @override
  Future<ApiResult<OrderAssignmentDetailsEntity?>> markOrderDelivered(
    String orderId, {
    Map<String, dynamic>? request,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.markOrderDelivered(
        orderId,
        request: request,
      );
      return response.updatedAssignment?.toEntity();
    });
  }

  @override
  Future<ApiResult<OrderAssignmentDetailsEntity?>> markOrderDeliveryFailed(
    String orderId, {
    Map<String, dynamic>? request,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.markOrderDeliveryFailed(
        orderId,
        request: request,
      );
      return response.updatedAssignment?.toEntity();
    });
  }

  @override
  Future<ApiResult<OrderAssignmentDetailsEntity?>> updateAssignmentStatus(
    String assignmentId, {
    required String newStatus,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.updateAssignmentStatus(
        assignmentId,
        newStatus: newStatus,
      );
      return response.updatedAssignment?.toEntity();
    });
  }

  @override
  Future<ApiResult<OrderAssignmentDetailsEntity?>> verifyDeliveryOtp(
    String assignmentId, {
    required String otpCode,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.verifyDeliveryOtp(
        assignmentId,
        otpCode: otpCode,
      );
      return response.updatedAssignment?.toEntity();
    });
  }

  @override
  Future<ApiResult<OrderAssignmentDetailsEntity?>> verifyPickupOtp(
    String assignmentId, {
    required String otpCode,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.verifyPickupOtp(
        assignmentId,
        otpCode: otpCode,
      );
      return response.updatedAssignment?.toEntity();
    });
  }

  @override
  Future<ApiResult<OrderAssignmentDetailsEntity?>> markOrderArrivedAtVendor(
    String orderId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.markOrderArrivedAtVendor(
        orderId,
      );
      return response.updatedAssignment?.toEntity();
    });
  }

  @override
  Future<ApiResult<OrderAssignmentDetailsEntity?>> markOrderArrivedAtCustomer(
    String orderId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.markOrderArrivedAtCustomer(
        orderId,
      );
      return response.updatedAssignment?.toEntity();
    });
  }
}
