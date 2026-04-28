import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/errors/api_exception_mapper.dart';
import 'package:zadana_delivery/core/network/api_services.dart';
import 'package:zadana_delivery/features/notifications/data/data_source/notifications_remote_data_source.dart';
import 'package:zadana_delivery/features/notifications/data/models/driver_notifications_response_model_dto.dart';
import 'package:zadana_delivery/features/notifications/data/models/notification_action_response_model_dto.dart';
import 'package:zadana_delivery/features/notifications/data/models/notification_unread_count_response_model_dto.dart';

@Injectable(as: NotificationsRemoteDataSource)
class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  const NotificationsRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<DriverNotificationsResponseModelDto> getNotifications({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await _apiServices.getDriverNotifications(
        page: page,
        perPage: perPage,
      );
      return DriverNotificationsResponseModelDto.fromJson(
        _normalizeMap(response),
      );
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<NotificationActionResponseModelDto> markAsRead(String id) async {
    try {
      final response = await _apiServices.markDriverNotificationAsRead(id);
      return NotificationActionResponseModelDto.fromJson(
        _normalizeMap(response),
      );
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<NotificationActionResponseModelDto> markAllAsRead() async {
    try {
      final response = await _apiServices.markAllDriverNotificationsAsRead();
      return NotificationActionResponseModelDto.fromJson(
        _normalizeMap(response),
      );
    } on DioException catch (exception) {
      throw ApiExceptionMapper.fromDioException(exception);
    }
  }

  @override
  Future<NotificationUnreadCountResponseModelDto> getUnreadCount() async {
    try {
      final response = await _apiServices.getDriverNotificationsUnreadCount();
      return NotificationUnreadCountResponseModelDto.fromJson(
        _normalizeMap(response),
      );
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
