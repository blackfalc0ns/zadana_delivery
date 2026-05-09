import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';
import 'package:zadana_delivery/features/order_details/data/data_source/order_details_remote_data_source.dart';
import 'package:zadana_delivery/features/order_details/data/models/order_assignment_details_model_dto.dart';
import 'package:zadana_delivery/features/order_details/data/models/order_details_action_response_dto.dart';

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
  Future<OrderDetailsActionResponseDto> markOrderPickedUp(
    String orderId,
  ) async {
    try {
      final response = await _apiServices.markOrderPickedUp(orderId);
      return OrderDetailsActionResponseDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<OrderDetailsActionResponseDto> markOrderOnTheWay(
    String orderId,
  ) async {
    try {
      final response = await _apiServices.markOrderOnTheWay(orderId);
      return OrderDetailsActionResponseDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<OrderDetailsActionResponseDto> markOrderDelivered(
    String orderId, {
    Map<String, dynamic>? request,
  }) async {
    try {
      final response = await _apiServices.markOrderDelivered(
        orderId,
        request ?? const {},
      );
      return OrderDetailsActionResponseDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<OrderDetailsActionResponseDto> markOrderDeliveryFailed(
    String orderId, {
    Map<String, dynamic>? request,
  }) async {
    try {
      final response = await _apiServices.markOrderDeliveryFailed(
        orderId,
        request ?? const {},
      );
      return OrderDetailsActionResponseDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<OrderDetailsActionResponseDto> updateAssignmentStatus(
    String assignmentId, {
    required String newStatus,
  }) async {
    try {
      final response = await _apiServices.updateDriverAssignmentStatus(
        assignmentId,
        {'newStatus': newStatus},
      );
      return OrderDetailsActionResponseDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<OrderDetailsActionResponseDto> verifyDeliveryOtp(
    String assignmentId, {
    required String otpCode,
  }) async {
    try {
      final response = await _apiServices.verifyDriverAssignmentOtp(
        assignmentId,
        {'otpType': 'delivery', 'otpCode': otpCode},
      );
      return OrderDetailsActionResponseDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<OrderDetailsActionResponseDto> verifyPickupOtp(
    String assignmentId, {
    required String otpCode,
  }) async {
    try {
      final response = await _apiServices.verifyDriverAssignmentOtp(
        assignmentId,
        {'otpType': 'pickup', 'otpCode': otpCode},
      );
      return OrderDetailsActionResponseDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<OrderDetailsActionResponseDto> resendDeliveryOtp(
    String assignmentId,
  ) async {
    try {
      final response = await _apiServices.resendDriverAssignmentOtp(
        assignmentId,
        const {'otpType': 'delivery'},
      );
      return OrderDetailsActionResponseDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<OrderDetailsActionResponseDto> resendPickupOtp(
    String assignmentId,
  ) async {
    try {
      final response = await _apiServices.resendDriverAssignmentOtp(
        assignmentId,
        const {'otpType': 'pickup'},
      );
      return OrderDetailsActionResponseDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<OrderDetailsActionResponseDto> markOrderArrivedAtVendor(
    String orderId,
  ) async {
    try {
      final response = await _apiServices.markOrderArrivedAtVendor(orderId);
      return OrderDetailsActionResponseDto.fromJson(_normalizeMap(response));
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<OrderDetailsActionResponseDto> markOrderArrivedAtCustomer(
    String orderId,
  ) async {
    try {
      final response = await _apiServices.markOrderArrivedAtCustomer(orderId);
      return OrderDetailsActionResponseDto.fromJson(_normalizeMap(response));
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
