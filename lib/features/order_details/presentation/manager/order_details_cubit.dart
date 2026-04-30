import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/services/driver_realtime_service.dart';
import 'package:zadana_delivery/core/services/driver_runtime_services_controller.dart';
import 'package:zadana_delivery/features/driver_home/domain/usecase/refresh_driver_home_usecase.dart';
import 'package:zadana_delivery/features/order_details/data/mapper/order_assignment_details_mapper.dart';
import 'package:zadana_delivery/features/order_details/data/models/order_assignment_details_model_dto.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_assignment_details_entity.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/get_order_assignment_details_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/mark_order_arrived_at_customer_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/mark_order_arrived_at_vendor_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/mark_order_delivered_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/mark_order_delivery_failed_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/mark_order_on_the_way_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/mark_order_picked_up_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/verify_delivery_otp_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/verify_pickup_otp_usecase.dart';
import 'package:zadana_delivery/features/order_details/presentation/manager/order_details_event.dart';
import 'package:zadana_delivery/features/order_details/presentation/manager/order_details_state.dart';

@injectable
class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  OrderDetailsCubit(this._getOrderAssignmentDetailsUseCase)
    : super(const OrderDetailsState());

  static const String _logTag = '[OrderDetailsRealtime]';

  final GetOrderAssignmentDetailsUseCase _getOrderAssignmentDetailsUseCase;
  final MarkOrderArrivedAtVendorUseCase _markOrderArrivedAtVendorUseCase =
      getIt<MarkOrderArrivedAtVendorUseCase>();
  final MarkOrderArrivedAtCustomerUseCase _markOrderArrivedAtCustomerUseCase =
      getIt<MarkOrderArrivedAtCustomerUseCase>();
  final MarkOrderPickedUpUseCase _markOrderPickedUpUseCase =
      getIt<MarkOrderPickedUpUseCase>();
  final MarkOrderOnTheWayUseCase _markOrderOnTheWayUseCase =
      getIt<MarkOrderOnTheWayUseCase>();
  final MarkOrderDeliveredUseCase _markOrderDeliveredUseCase =
      getIt<MarkOrderDeliveredUseCase>();
  final MarkOrderDeliveryFailedUseCase _markOrderDeliveryFailedUseCase =
      getIt<MarkOrderDeliveryFailedUseCase>();
  final VerifyDeliveryOtpUseCase _verifyDeliveryOtpUseCase =
      getIt<VerifyDeliveryOtpUseCase>();
  final VerifyPickupOtpUseCase _verifyPickupOtpUseCase =
      getIt<VerifyPickupOtpUseCase>();
  final RefreshDriverHomeUseCase _refreshDriverHomeUseCase =
      getIt<RefreshDriverHomeUseCase>();
  final DriverRealtimeService _driverRealtimeService =
      getIt<DriverRealtimeService>();
  final DriverRuntimeServicesController _driverRuntimeServicesController =
      getIt<DriverRuntimeServicesController>();

  StreamSubscription<Map<String, dynamic>>? _notificationSubscription;
  StreamSubscription<Map<String, dynamic>>? _orderStatusSubscription;
  StreamSubscription<Map<String, dynamic>>? _arrivalStateSubscription;
  StreamSubscription<Map<String, dynamic>>? _assignmentUpdatedSubscription;
  Timer? _assignmentPollingTimer;
  String? _activeAssignmentId;
  String? _activeOrderId;

  Future<bool> doIntent(OrderDetailsEvent event) async {
    switch (event) {
      case OrderDetailsLoadAssignmentEvent():
        await _loadAssignmentDetails(event.assignmentId, silent: event.silent);
        return true;
      case OrderDetailsClearErrorEvent():
        clearError();
        return true;
      case OrderDetailsActivateRealtimeEvent():
        await _activateRealtime(
          assignmentId: event.assignmentId,
          orderId: event.orderId,
        );
        return true;
      case OrderDetailsDeactivateRealtimeEvent():
        await _deactivateRealtime();
        return true;
      case OrderDetailsConsumeNotificationEvent():
        emit(state.copyWith(clearNotificationMessage: true));
        return true;
      case OrderDetailsMarkPickedUpEvent():
        return _runAction(() => _markOrderPickedUpUseCase.call(event.orderId));
      case OrderDetailsMarkOnTheWayEvent():
        return _runAction(
          () => _markOrderOnTheWayUseCase.call(event.orderId),
          onSuccessRefreshAssignment: true,
        );
      case OrderDetailsMarkDeliveredEvent():
        return _runAction(
          () => _markOrderDeliveredUseCase.call(
            event.orderId,
            request: event.request,
          ),
          onSuccessRefreshAssignment: true,
        );
      case OrderDetailsMarkDeliveryFailedEvent():
        return _runAction(
          () => _markOrderDeliveryFailedUseCase.call(
            event.orderId,
            request: event.request,
          ),
          onSuccessRefreshAssignment: true,
        );
      case OrderDetailsUpdateArrivalStateEvent():
        return _runAction(
          () => _markArrivalState(event.orderId, event.arrivalState),
          onSuccessRefreshAssignment: true,
        );
      case OrderDetailsVerifyDeliveryOtpEvent():
        return _runAction(
          () => _verifyDeliveryOtpUseCase.call(
            event.assignmentId,
            otpCode: event.otpCode,
          ),
          onSuccessRefreshAssignment: true,
        );
      case OrderDetailsVerifyPickupOtpEvent():
        return _runAction(
          () => _verifyPickupOtpUseCase.call(
            event.assignmentId,
            otpCode: event.otpCode,
          ),
          onSuccessRefreshAssignment: true,
        );
    }
  }

  Future<void> _loadAssignmentDetails(
    String assignmentId, {
    bool silent = false,
  }) async {
    if (!silent) {
      emit(state.copyWith(isLoading: true, clearFailure: true));
    }

    final result = await _getOrderAssignmentDetailsUseCase.call(assignmentId);
    switch (result) {
      case ApiSuccessResult():
        final resolvedOrderId = result.data.orderId.trim();
        if (resolvedOrderId.isNotEmpty) {
          _activeOrderId = resolvedOrderId;
        }
        emit(
          state.copyWith(
            isLoading: false,
            details: result.data,
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        if (!silent || state.details == null) {
          emit(state.copyWith(isLoading: false, failure: result.failure));
        } else {
          emit(state.copyWith(isLoading: false));
        }
    }
  }

  void clearError() {
    if (state.failure == null) return;
    emit(state.copyWith(clearFailure: true));
  }

  Future<bool> _runAction<T>(
    Future<ApiResult<T>> Function() action, {
    bool onSuccessRefreshAssignment = false,
  }) async {
    emit(state.copyWith(isActionLoading: true, clearFailure: true));
    final result = await action();
    switch (result) {
      case ApiSuccessResult(data: final data):
        if (data is OrderAssignmentDetailsEntity) {
          final resolvedOrderId = data.orderId.trim();
          if (resolvedOrderId.isNotEmpty) {
            _activeOrderId = resolvedOrderId;
          }
          emit(
            state.copyWith(
              details: data,
              isActionLoading: false,
              clearFailure: true,
            ),
          );
        } else {
          emit(state.copyWith(isActionLoading: false, clearFailure: true));
        }
        await _refreshDriverHomeUseCase.call();
        if (onSuccessRefreshAssignment && _activeAssignmentId != null) {
          await _loadAssignmentDetails(_activeAssignmentId!, silent: true);
        }
        return true;
      case ApiErrorResult():
        emit(state.copyWith(isActionLoading: false, failure: result.failure));
        return false;
    }
  }

  Future<ApiResult<OrderAssignmentDetailsEntity?>> _markArrivalState(
    String orderId,
    String arrivalState,
  ) {
    final normalizedState = arrivalState.trim().toLowerCase();
    if (normalizedState == 'arrived_at_vendor') {
      return _markOrderArrivedAtVendorUseCase.call(orderId);
    }
    if (normalizedState == 'arrived_at_customer') {
      return _markOrderArrivedAtCustomerUseCase.call(orderId);
    }
    throw ArgumentError.value(
      arrivalState,
      'arrivalState',
      'Unsupported arrival state action',
    );
  }

  Future<void> _activateRealtime({
    required String assignmentId,
    required String orderId,
  }) async {
    _activeAssignmentId = assignmentId;
    _activeOrderId = orderId;
    _log('Activating realtime: assignmentId=$assignmentId, orderId=$orderId');

    try {
      await _driverRuntimeServicesController.initializeDriverRuntimeServices();
    } catch (error) {
      _log('Runtime services initialization failed: $error');
    }

    await _driverRealtimeService.ensureConnected();
    await _notificationSubscription?.cancel();
    await _orderStatusSubscription?.cancel();
    await _arrivalStateSubscription?.cancel();
    _assignmentPollingTimer?.cancel();

    _notificationSubscription = _driverRealtimeService.notifications.listen((
      payload,
    ) {
      _log(
        'Notification stream event in order details: '
        'type=${payload['type'] ?? 'unknown'}, orderId=${payload['orderId'] ?? 'n/a'}',
      );
      final title = payload['titleAr']?.toString().trim().isNotEmpty == true
          ? payload['titleAr']!.toString().trim()
          : payload['titleEn']?.toString().trim() ?? '';
      final body = payload['bodyAr']?.toString().trim().isNotEmpty == true
          ? payload['bodyAr']!.toString().trim()
          : payload['bodyEn']?.toString().trim() ?? '';
      final message = [
        title,
        body,
      ].where((value) => value.trim().isNotEmpty).join('\n');
      if (message.trim().isEmpty) return;
      _log('Notification banner emitted to UI');
      emit(state.copyWith(notificationMessage: message.trim()));
    });

    _orderStatusSubscription = _driverRealtimeService.orderStatusChanged.listen((
      payload,
    ) {
      _log(
        'Order status stream event received: orderId=${payload['orderId'] ?? 'n/a'}, '
        'status=${payload['status'] ?? payload['newStatus'] ?? 'unknown'}',
      );
      final orderIdValue = payload['orderId']?.toString().trim() ?? '';
      if (orderIdValue.isEmpty || orderIdValue != _activeOrderId) return;
      final assignmentIdValue = _activeAssignmentId;
      if (assignmentIdValue == null) return;
      _log('Order status matched active order; reloading assignment details');
      unawaited(_loadAssignmentDetails(assignmentIdValue, silent: true));
      unawaited(_refreshDriverHomeUseCase.call());
    });

    _arrivalStateSubscription = _driverRealtimeService.arrivalStateChanged.listen((
      payload,
    ) {
      _log(
        'Arrival state stream event received: orderId=${payload['orderId'] ?? 'n/a'}, '
        'arrivalState=${payload['arrivalState'] ?? payload['state'] ?? 'unknown'}',
      );
      final orderIdValue = payload['orderId']?.toString().trim() ?? '';
      if (orderIdValue.isEmpty || orderIdValue != _activeOrderId) return;
      final assignmentIdValue = _activeAssignmentId;
      if (assignmentIdValue == null) return;
      _log('Arrival state matched active order; reloading assignment details');
      unawaited(_loadAssignmentDetails(assignmentIdValue, silent: true));
      unawaited(_refreshDriverHomeUseCase.call());
    });

    // ⭐ PRIMARY: ReceiveAssignmentUpdated — full DTO directly from backend
    _assignmentUpdatedSubscription = _driverRealtimeService.assignmentUpdated.listen((
      payload,
    ) {
      _log(
        'Assignment updated stream event received: '
        'assignmentId=${payload['assignmentId'] ?? 'n/a'}, '
        'assignmentStatus=${payload['assignmentStatus'] ?? 'unknown'}',
      );
      final assignmentIdValue = payload['assignmentId']?.toString().trim() ?? '';
      if (assignmentIdValue.isEmpty || assignmentIdValue != _activeAssignmentId) {
        _log('Assignment updated event ignored: does not match active assignment');
        return;
      }
      try {
        final dto = OrderAssignmentDetailsModelDto.fromJson(payload);
        final entity = dto.toEntity();
        _log(
          'Assignment updated: applying realtime state update '
          '(status=${entity.assignmentStatus}, actions=${entity.allowedActions})',
        );
        emit(state.copyWith(details: entity, isLoading: false));
        unawaited(_refreshDriverHomeUseCase.call());
      } catch (error) {
        _log('Failed to parse assignment updated payload: $error. Falling back to GET.');
        unawaited(_loadAssignmentDetails(assignmentIdValue, silent: true));
      }
    });
  }

  Future<void> _deactivateRealtime() async {
    _log('Deactivating realtime and cancelling subscriptions');
    _activeAssignmentId = null;
    _activeOrderId = null;
    _assignmentPollingTimer?.cancel();
    _assignmentPollingTimer = null;
    await _notificationSubscription?.cancel();
    await _orderStatusSubscription?.cancel();
    await _arrivalStateSubscription?.cancel();
    await _assignmentUpdatedSubscription?.cancel();
    _notificationSubscription = null;
    _orderStatusSubscription = null;
    _arrivalStateSubscription = null;
    _assignmentUpdatedSubscription = null;
    emit(state.copyWith(clearNotificationMessage: true));
  }

  void _log(String message) {
    debugPrint('$_logTag $message');
  }

  @override
  Future<void> close() async {
    await _deactivateRealtime();
    return super.close();
  }
}
