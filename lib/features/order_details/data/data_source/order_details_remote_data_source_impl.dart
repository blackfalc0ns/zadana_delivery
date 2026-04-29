import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';
import 'package:zadana_delivery/features/order_details/data/data_source/order_details_remote_data_source.dart';
import 'package:zadana_delivery/features/order_details/data/models/order_assignment_details_model_dto.dart';

@Injectable(as: OrderDetailsRemoteDataSource)
class OrderDetailsRemoteDataSourceImpl implements OrderDetailsRemoteDataSource {
  const OrderDetailsRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<OrderAssignmentDetailsModelDto> getAssignmentDetails(
    String assignmentId,
  ) async {
    try {
      final response = await _apiServices.getDriverAssignmentDetails(
        assignmentId,
      );
      return OrderAssignmentDetailsModelDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<void> markOrderPickedUp(String orderId) async {
    try {
      await _apiServices.markOrderPickedUp(orderId);
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<void> markOrderOnTheWay(String orderId) async {
    try {
      await _apiServices.markOrderOnTheWay(orderId);
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<void> markOrderDelivered(
    String orderId, {
    Map<String, dynamic>? request,
  }) async {
    try {
      await _apiServices.markOrderDelivered(orderId, request ?? const {});
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<void> markOrderDeliveryFailed(
    String orderId, {
    Map<String, dynamic>? request,
  }) async {
    try {
      await _apiServices.markOrderDeliveryFailed(orderId, request ?? const {});
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<void> updateAssignmentStatus(
    String assignmentId, {
    required String newStatus,
  }) async {
    try {
      await _apiServices.updateDriverAssignmentStatus(assignmentId, {
        'newStatus': newStatus,
      });
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<void> verifyDeliveryOtp(
    String assignmentId, {
    required String otpCode,
  }) async {
    try {
      await _apiServices.verifyDriverAssignmentOtp(assignmentId, {
        'otpType': 'delivery',
        'otpCode': otpCode,
      });
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<void> markOrderArrivedAtVendor(String orderId) async {
    try {
      await _apiServices.markOrderArrivedAtVendor(orderId);
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<void> markOrderArrivedAtCustomer(String orderId) async {
    try {
      await _apiServices.markOrderArrivedAtCustomer(orderId);
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  Map<String, dynamic> _normalizeMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }
}
