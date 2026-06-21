import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/models/localized_message.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/services/driver_realtime_service.dart';
import 'package:zadana_delivery/core/services/driver_runtime_services_controller.dart';
import 'package:zadana_delivery/core/services/language_service.dart';
import 'package:zadana_delivery/features/driver_home/domain/usecase/accept_driver_offer_usecase.dart';
import 'package:zadana_delivery/features/driver_home/domain/usecase/refresh_driver_home_usecase.dart';
import 'package:zadana_delivery/features/driver_home/domain/usecase/reject_driver_offer_usecase.dart';
import 'package:zadana_delivery/features/driver_support/domain/usecase/create_driver_order_dispute_usecase.dart';
import 'package:zadana_delivery/features/driver_support/domain/usecase/report_driver_order_issue_usecase.dart';
import 'package:zadana_delivery/features/order_details/data/mapper/order_assignment_details_mapper.dart';
import 'package:zadana_delivery/features/order_details/data/models/order_assignment_details_model_dto.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_assignment_details_entity.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_details_action_result_entity.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/get_order_assignment_details_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/mark_order_arrived_at_customer_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/mark_order_arrived_at_vendor_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/mark_order_delivered_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/mark_order_delivery_failed_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/mark_order_on_the_way_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/mark_order_picked_up_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/resend_delivery_otp_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/resend_pickup_otp_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/verify_delivery_otp_usecase.dart';
import 'package:zadana_delivery/features/order_details/domain/usecase/verify_pickup_otp_usecase.dart';
import 'package:zadana_delivery/features/order_details/presentation/manager/order_details_event.dart';
import 'package:zadana_delivery/features/order_details/presentation/manager/order_details_state.dart';

@injectable
class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  OrderDetailsCubit(this._getOrderAssignmentDetailsUseCase)
    : super(const OrderDetailsState());

  static const String _logTag = '[OrderDetailsRealtime]';
  static const Duration _arrivedAtVendorPollingInterval = Duration(seconds: 10);

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
  final ResendDeliveryOtpUseCase _resendDeliveryOtpUseCase =
      getIt<ResendDeliveryOtpUseCase>();
  final ResendPickupOtpUseCase _resendPickupOtpUseCase =
      getIt<ResendPickupOtpUseCase>();
  final AcceptDriverOfferUseCase _acceptDriverOfferUseCase =
      getIt<AcceptDriverOfferUseCase>();
  final RefreshDriverHomeUseCase _refreshDriverHomeUseCase =
      getIt<RefreshDriverHomeUseCase>();
  final RejectDriverOfferUseCase _rejectDriverOfferUseCase =
      getIt<RejectDriverOfferUseCase>();
  final ReportDriverOrderIssueUseCase _reportDriverOrderIssueUseCase =
      getIt<ReportDriverOrderIssueUseCase>();
  final CreateDriverOrderDisputeUseCase _createDriverOrderDisputeUseCase =
      getIt<CreateDriverOrderDisputeUseCase>();
  final LanguageService _languageService = getIt<LanguageService>();
  final DriverRealtimeService _driverRealtimeService =
      getIt<DriverRealtimeService>();
  final DriverRuntimeServicesController _driverRuntimeServicesController =
      getIt<DriverRuntimeServicesController>();
  int _loadRequestSerial = 0;
  StreamSubscription<Map<String, dynamic>>? _notificationSubscription;
  StreamSubscription<Map<String, dynamic>>? _assignmentUpdatedSubscription;
  StreamSubscription<Map<String, dynamic>>? _orderStatusSubscription;
  StreamSubscription<Map<String, dynamic>>? _arrivalStateSubscription;
  Timer? _assignmentPollingTimer;
  String? _activeAssignmentId;
  String? _activeOrderId;
  DateTime? _lastLocalActionAt;

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
      case OrderDetailsConsumeBlockingMessageEvent():
        emit(
          state.copyWith(clearBlockingMessage: true, shouldCloseScreen: false),
        );
        return true;
      case OrderDetailsAcceptOfferEvent():
        return _acceptOffer(event.assignmentId);
      case OrderDetailsRejectOfferEvent():
        return _rejectOffer(event.assignmentId, reason: event.reason);
      case OrderDetailsMarkPickedUpEvent():
        return _runAction(
          () => _markOrderPickedUpUseCase.call(event.orderId),
          onSuccessRefreshAssignment: true,
          onSuccessRefreshHome: false,
        );
      case OrderDetailsMarkOnTheWayEvent():
        return _runAction(
          () => _markOrderOnTheWayUseCase.call(event.orderId),
          onSuccessRefreshAssignment: true,
          onSuccessRefreshHome: false,
        );
      case OrderDetailsMarkDeliveredEvent():
        return _runAction(
          () => _markOrderDeliveredUseCase.call(
            event.orderId,
            request: event.request,
          ),
          onSuccessRefreshAssignment: true,
          onSuccessRefreshHome: false,
        );
      case OrderDetailsMarkDeliveryFailedEvent():
        return _runAction(
          () => _markOrderDeliveryFailedUseCase.call(
            event.orderId,
            request: event.request,
          ),
          onSuccessRefreshAssignment: true,
          onSuccessRefreshHome: false,
        );
      case OrderDetailsUpdateArrivalStateEvent():
        return _runAction(
          () => _markArrivalState(event.orderId, event.arrivalState),
          onSuccessRefreshAssignment: true,
          onSuccessRefreshHome: false,
        );
      case OrderDetailsVerifyDeliveryOtpEvent():
        return _runAction(
          () => _verifyDeliveryOtpUseCase.call(
            event.assignmentId,
            otpCode: event.otpCode,
          ),
          onSuccessRefreshAssignment: true,
          onSuccessRefreshHome: false,
        );
      case OrderDetailsVerifyPickupOtpEvent():
        return _runAction(
          () => _verifyPickupOtpUseCase.call(
            event.assignmentId,
            otpCode: event.otpCode,
          ),
          onSuccessRefreshAssignment: true,
          onSuccessRefreshHome: false,
        );
      case OrderDetailsResendDeliveryOtpEvent():
        return _runAction(
          () => _resendDeliveryOtpUseCase.call(event.assignmentId),
          onSuccessRefreshAssignment: true,
          onSuccessRefreshHome: false,
        );
      case OrderDetailsResendPickupOtpEvent():
        return _runAction(
          () => _resendPickupOtpUseCase.call(event.assignmentId),
          onSuccessRefreshAssignment: true,
          onSuccessRefreshHome: false,
        );
      case OrderDetailsReportIssueEvent():
        return _runSupportCaseAction(
          () => _reportDriverOrderIssueUseCase.call(
            event.orderId,
            request: event.request,
          ),
          successMessageAr: 'تم إرسال المشكلة بنجاح',
          successMessageEn: 'Issue reported successfully',
        );
      case OrderDetailsCreateDisputeEvent():
        return _runSupportCaseAction(
          () => _createDriverOrderDisputeUseCase.call(
            event.orderId,
            request: event.request,
          ),
          successMessageAr: 'تم فتح النزاع بنجاح',
          successMessageEn: 'Dispute created successfully',
        );
    }
  }

  Future<void> _loadAssignmentDetails(
    String assignmentId, {
    bool silent = false,
  }) async {
    final requestSerial = ++_loadRequestSerial;
    if (!silent) {
      emit(state.copyWith(isLoading: true, clearFailure: true));
    }

    final result = await _getOrderAssignmentDetailsUseCase.call(assignmentId);
    switch (result) {
      case ApiSuccessResult():
        if (requestSerial != _loadRequestSerial) return;
        final resolvedOrderId = result.data.orderId.trim();
        if (resolvedOrderId.isNotEmpty) {
          _activeOrderId = resolvedOrderId;
        }
        _syncArrivedAtVendorPolling(result.data);
        emit(
          state.copyWith(
            isLoading: false,
            details: result.data,
            clearFailure: true,
          ),
        );
      case ApiErrorResult():
        if (requestSerial != _loadRequestSerial) return;
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

  Future<void> _activateRealtime({
    required String assignmentId,
    required String orderId,
  }) async {
    _activeAssignmentId = assignmentId.trim();
    _activeOrderId = orderId.trim();
    _log(
      'Activating realtime: assignmentId=$_activeAssignmentId, orderId=$_activeOrderId',
    );

    try {
      await _driverRuntimeServicesController.initializeDriverRuntimeServices();
    } catch (error) {
      _log('Runtime services initialization failed: $error');
    }

    await _driverRealtimeService.initialize();
    await _driverRealtimeService.ensureConnected();
    await _driverRealtimeService.subscribeToOrderTracking(_activeOrderId ?? '');

    await _notificationSubscription?.cancel();
    await _assignmentUpdatedSubscription?.cancel();
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
      emit(
        state.copyWith(clearFailure: true, notificationMessage: message.trim()),
      );
    });

    _orderStatusSubscription = _driverRealtimeService.orderTrackingStatusChanged
        .listen((payload) {
          _log(
            'Order tracking status stream event received: '
            'orderId=${payload['orderId'] ?? 'n/a'}, '
            'newStatus=${payload['newStatus'] ?? 'unknown'}, '
            'actorRole=${payload['actorRole'] ?? 'unknown'}',
          );
          final orderIdValue = payload['orderId']?.toString().trim() ?? '';
          if (orderIdValue.isEmpty || orderIdValue != _activeOrderId) return;
          final actorRole = payload['actorRole']
              ?.toString()
              .trim()
              .toLowerCase();
          if (actorRole == 'driver') {
            _log(
              'Ignoring order tracking status event triggered by the driver',
            );
            return;
          }
          final newStatus = _normalizeToken(
            payload['newStatus']?.toString() ?? '',
          );
          if (_isCancellationStatus(newStatus)) {
            emit(
              state.copyWith(
                blockingMessage: _resolveCancellationMessage(payload),
                shouldCloseScreen: true,
              ),
            );
            return;
          }
          final assignmentIdValue = _activeAssignmentId;
          if (assignmentIdValue == null) return;
          unawaited(_loadAssignmentDetails(assignmentIdValue, silent: true));
        });

    _arrivalStateSubscription = _driverRealtimeService
        .orderTrackingArrivalStateChanged
        .listen((payload) {
          _log(
            'Order tracking arrival state event received: '
            'orderId=${payload['orderId'] ?? 'n/a'}, '
            'arrivalState=${payload['arrivalState'] ?? payload['state'] ?? 'unknown'}, '
            'actorRole=${payload['actorRole'] ?? 'unknown'}',
          );
        });

    _assignmentUpdatedSubscription = _driverRealtimeService.assignmentUpdated
        .listen((payload) {
          _log(
            'Assignment updated stream event received: '
            'assignmentId=${payload['assignmentId'] ?? 'n/a'}, '
            'assignmentStatus=${payload['assignmentStatus'] ?? 'unknown'}, '
            'driverArrivalState=${payload['driverArrivalState'] ?? 'n/a'}',
          );
          final assignmentIdValue =
              payload['assignmentId']?.toString().trim() ?? '';
          if (assignmentIdValue.isEmpty ||
              assignmentIdValue != _activeAssignmentId) {
            return;
          }
          // Ignore stale SignalR updates that arrive shortly after a successful local action
          // Extended to 20 seconds to prevent premature status changes after driver actions
          final lastActionAt = _lastLocalActionAt;
          if (lastActionAt != null &&
              DateTime.now().difference(lastActionAt).inSeconds < 20) {
            _log('Ignoring potentially stale assignment update (recent local action within 20s)');
            return;
          }
          
          // Note: Removed blocking logic to allow immediate status updates
          
          try {
            final entity = OrderAssignmentDetailsModelDto.fromJson(
              payload,
            ).toEntity();
            _syncArrivedAtVendorPolling(entity);
            emit(
              state.copyWith(
                details: entity,
                isLoading: false,
                clearFailure: true,
              ),
            );
          } catch (error) {
            _log('Failed to parse assignment update payload: $error');
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
    await _driverRealtimeService.unsubscribeFromOrderTracking();
    await _notificationSubscription?.cancel();
    await _assignmentUpdatedSubscription?.cancel();
    await _orderStatusSubscription?.cancel();
    await _arrivalStateSubscription?.cancel();
    _notificationSubscription = null;
    _assignmentUpdatedSubscription = null;
    _orderStatusSubscription = null;
    _arrivalStateSubscription = null;
    if (isClosed) return;
    emit(
      state.copyWith(
        clearNotificationMessage: true,
        clearBlockingMessage: true,
        shouldCloseScreen: false,
      ),
    );
  }

  void _syncArrivedAtVendorPolling(OrderAssignmentDetailsEntity details) {
    if (_shouldPollArrivedAtVendor(details)) {
      _startArrivedAtVendorPolling();
      return;
    }
    _stopArrivedAtVendorPolling();
  }

  bool _shouldPollArrivedAtVendor(OrderAssignmentDetailsEntity details) {
    final assignmentStatus = _normalizeToken(details.assignmentStatus);
    final arrivalState = _normalizeToken(details.driverArrivalState);

    if (_statusIn(assignmentStatus, const {
          'pickedup',
          'ontheway',
          'outfordelivery',
          'arrivedatcustomer',
          'delivered',
          'deliveryfailed',
          'failed',
          'cancelled',
          'canceled',
          'completed',
        }) ||
        _statusIn(arrivalState, const {
          'arrivedatcustomer',
          'enroutetocustomer',
        })) {
      return false;
    }

    return _statusIn(assignmentStatus, const {'arrivedatvendor'}) ||
        _statusIn(arrivalState, const {'arrivedatvendor'});
  }

  void _startArrivedAtVendorPolling() {
    if (_assignmentPollingTimer?.isActive == true) return;
    final assignmentId = _activeAssignmentId;
    if ((assignmentId ?? '').isEmpty) return;
    _log('Starting arrived-at-vendor polling');
    _assignmentPollingTimer = Timer.periodic(_arrivedAtVendorPollingInterval, (
      _,
    ) {
      final currentAssignmentId = _activeAssignmentId;
      if ((currentAssignmentId ?? '').isEmpty) return;
      unawaited(_loadAssignmentDetails(currentAssignmentId!, silent: true));
    });
  }

  void _stopArrivedAtVendorPolling() {
    if (_assignmentPollingTimer == null) return;
    _log('Stopping arrived-at-vendor polling');
    _assignmentPollingTimer?.cancel();
    _assignmentPollingTimer = null;
  }

  String _resolveLocalizedMessage(LocalizedMessage message) {
    final isArabic = _languageService.getLanguageCode() == 'ar';
    return message.resolve(isArabic: isArabic);
  }

  Future<bool> _acceptOffer(String assignmentId) async {
    emit(
      state.copyWith(
        isActionLoading: true,
        clearFailure: true,
        clearNotificationMessage: true,
      ),
    );

    final result = await _acceptDriverOfferUseCase.call(assignmentId);
    switch (result) {
      case ApiSuccessResult():
        final successMessage = _resolveLocalizedMessage(result.data);
        emit(
          state.copyWith(
            isActionLoading: false,
            clearFailure: true,
            notificationMessage: successMessage,
          ),
        );
        await _refreshDriverHomeUseCase.call();
        final activeAssignmentId = _activeAssignmentId;
        if (activeAssignmentId != null) {
          await _loadAssignmentDetails(activeAssignmentId, silent: true);
        }
        return true;
      case ApiErrorResult():
        emit(state.copyWith(isActionLoading: false, failure: result.failure));
        return false;
    }
  }

  Future<bool> _rejectOffer(String assignmentId, {String? reason}) async {
    emit(
      state.copyWith(
        isActionLoading: true,
        clearFailure: true,
        clearNotificationMessage: true,
      ),
    );

    final result = await _rejectDriverOfferUseCase.call(
      assignmentId,
      reason: reason,
    );
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isActionLoading: false,
            clearFailure: true,
            notificationMessage: _resolveLocalizedMessage(result.data),
          ),
        );
        await _refreshDriverHomeUseCase.call();
        return true;
      case ApiErrorResult():
        emit(state.copyWith(isActionLoading: false, failure: result.failure));
        return false;
    }
  }

  Future<bool> _runAction(
    Future<ApiResult<OrderDetailsActionResultEntity>> Function() action, {
    bool onSuccessRefreshAssignment = false,
    bool onSuccessRefreshHome = true,
    bool silent = false,
  }) async {
    if (!silent) {
      emit(
        state.copyWith(
          isActionLoading: true,
          clearFailure: true,
          clearNotificationMessage: true,
        ),
      );
    } else {
      emit(state.copyWith(clearFailure: true, clearNotificationMessage: true));
    }
    final result = await action();
    switch (result) {
      case ApiSuccessResult():
        // Track when a local action succeeded to help filter stale SignalR updates
        _lastLocalActionAt = DateTime.now();
        final localizedMessage = result.data.localizedMessage;
        final updatedAssignment = result.data.updatedAssignment;
        // Emit the updated assignment directly from the action response so the
        // UI transitions immediately without waiting for the silent refresh.
        emit(
          state.copyWith(
            isActionLoading: false,
            clearFailure: true,
            details: updatedAssignment,
            notificationMessage: localizedMessage == null
                ? null
                : _resolveLocalizedMessage(localizedMessage),
          ),
        );
        if (updatedAssignment != null) {
          _syncArrivedAtVendorPolling(updatedAssignment);
        }
        if (onSuccessRefreshHome) {
          await _refreshDriverHomeUseCase.call();
        }
        if (onSuccessRefreshAssignment && _activeAssignmentId != null) {
          await _loadAssignmentDetails(_activeAssignmentId!, silent: true);
        }
        return true;
      case ApiErrorResult():
        emit(state.copyWith(isActionLoading: false, failure: result.failure));
        return false;
    }
  }

  Future<bool> _runSupportCaseAction(
    Future<ApiResult<dynamic>> Function() action, {
    required String successMessageAr,
    required String successMessageEn,
  }) async {
    emit(
      state.copyWith(
        isActionLoading: true,
        clearFailure: true,
        clearNotificationMessage: true,
      ),
    );
    final result = await action();
    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isActionLoading: false,
            clearFailure: true,
            notificationMessage: _languageService.getLanguageCode() == 'ar'
                ? successMessageAr
                : successMessageEn,
          ),
        );
        return true;
      case ApiErrorResult():
        emit(state.copyWith(isActionLoading: false, failure: result.failure));
        return false;
    }
  }

  String _normalizeToken(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  bool _statusIn(String value, Set<String> candidates) {
    return candidates.contains(value);
  }

  bool _isCancellationStatus(String value) {
    return _statusIn(value, const {'cancelled', 'canceled', 'refunded'});
  }

  String _resolveCancellationMessage(Map<String, dynamic> payload) {
    final orderNumber = payload['orderNumber']?.toString().trim() ?? '';
    if (orderNumber.isEmpty) {
      return 'تم إلغاء الطلب.';
    }
    return 'تم إلغاء الطلب رقم $orderNumber.';
  }

  Future<ApiResult<OrderDetailsActionResultEntity>> _markArrivalState(
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

  void _log(String message) {
    debugPrint('$_logTag $message');
  }

  @override
  Future<void> close() async {
    await _deactivateRealtime();
    return super.close();
  }
}
