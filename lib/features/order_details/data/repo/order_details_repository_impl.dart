import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/models/localized_message.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/order_details/data/data_source/order_details_remote_data_source.dart';
import 'package:zadana_delivery/features/order_details/data/mapper/order_assignment_details_mapper.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_assignment_details_entity.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_details_action_result_entity.dart';
import 'package:zadana_delivery/features/order_details/domain/repo/order_details_repository.dart';

@Injectable(as: OrderDetailsRepository)
class OrderDetailsRepositoryImpl implements OrderDetailsRepository {
  const OrderDetailsRepositoryImpl(this._remoteDataSource);

  final OrderDetailsRemoteDataSource _remoteDataSource;

  OrderDetailsActionResultEntity _mapActionResult(dynamic response) {
    final status = _firstNonEmptyString([response.newStatus, response.status]);
    final updatedAssignment = _patchUpdatedAssignmentFromActionResponse(
      response.updatedAssignment?.toEntity(),
      status: status,
      arrivalState: response.arrivalState?.toString(),
    );
    return OrderDetailsActionResultEntity(
      updatedAssignment: updatedAssignment,
      localizedMessage:
          (response.messageAr != null || response.messageEn != null)
          ? LocalizedMessage(
              ar: response.messageAr ?? response.messageEn ?? '',
              en: response.messageEn ?? response.messageAr ?? '',
            )
          : null,
      status: response.status?.toString(),
      oldStatus: response.oldStatus?.toString(),
      newStatus: response.newStatus?.toString(),
      arrivalState: response.arrivalState?.toString(),
    );
  }

  OrderAssignmentDetailsEntity? _patchUpdatedAssignmentFromActionResponse(
    OrderAssignmentDetailsEntity? assignment, {
    String? status,
    String? arrivalState,
  }) {
    if (assignment == null) return null;

    final normalizedStatus = status?.trim();
    final normalizedArrivalState = arrivalState?.trim();

    if ((normalizedStatus ?? '').isEmpty &&
        (normalizedArrivalState ?? '').isEmpty) {
      return assignment;
    }

    return assignment.copyWith(
      assignmentStatus: (normalizedStatus ?? '').isEmpty
          ? null
          : normalizedStatus,
      driverArrivalState: (normalizedArrivalState ?? '').isEmpty
          ? null
          : normalizedArrivalState,
    );
  }

  String? _firstNonEmptyString(List<dynamic> candidates) {
    for (final candidate in candidates) {
      final value = candidate?.toString().trim();
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }

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
  Future<ApiResult<OrderDetailsActionResultEntity>> markOrderPickedUp(
    String orderId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.markOrderPickedUp(orderId);
      return _mapActionResult(response);
    });
  }

  @override
  Future<ApiResult<OrderDetailsActionResultEntity>> markOrderOnTheWay(
    String orderId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.markOrderOnTheWay(orderId);
      return _mapActionResult(response);
    });
  }

  @override
  Future<ApiResult<OrderDetailsActionResultEntity>> markOrderDelivered(
    String orderId, {
    Map<String, dynamic>? request,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.markOrderDelivered(
        orderId,
        request: request,
      );
      return _mapActionResult(response);
    });
  }

  @override
  Future<ApiResult<OrderDetailsActionResultEntity>> markOrderDeliveryFailed(
    String orderId, {
    Map<String, dynamic>? request,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.markOrderDeliveryFailed(
        orderId,
        request: request,
      );
      return _mapActionResult(response);
    });
  }

  @override
  Future<ApiResult<OrderDetailsActionResultEntity>> updateAssignmentStatus(
    String assignmentId, {
    required String newStatus,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.updateAssignmentStatus(
        assignmentId,
        newStatus: newStatus,
      );
      return _mapActionResult(response);
    });
  }

  @override
  Future<ApiResult<OrderDetailsActionResultEntity>> verifyDeliveryOtp(
    String assignmentId, {
    required String otpCode,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.verifyDeliveryOtp(
        assignmentId,
        otpCode: otpCode,
      );
      return _mapActionResult(response);
    });
  }

  @override
  Future<ApiResult<OrderDetailsActionResultEntity>> verifyPickupOtp(
    String assignmentId, {
    required String otpCode,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.verifyPickupOtp(
        assignmentId,
        otpCode: otpCode,
      );
      return _mapActionResult(response);
    });
  }

  @override
  Future<ApiResult<OrderDetailsActionResultEntity>> markOrderArrivedAtVendor(
    String orderId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.markOrderArrivedAtVendor(
        orderId,
      );
      return _mapActionResult(response);
    });
  }

  @override
  Future<ApiResult<OrderDetailsActionResultEntity>> markOrderArrivedAtCustomer(
    String orderId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.markOrderArrivedAtCustomer(
        orderId,
      );
      return _mapActionResult(response);
    });
  }
}
