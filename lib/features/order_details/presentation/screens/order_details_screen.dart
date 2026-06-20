import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_presentation.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_reject_order_dialog.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_message_request_entity.dart';
import 'package:zadana_delivery/features/order_details/presentation/controllers/order_details_controller.dart';
import 'package:zadana_delivery/features/order_details/presentation/helpers/order_details_launcher.dart';
import 'package:zadana_delivery/features/order_details/presentation/helpers/order_details_sheets.dart';
import 'package:zadana_delivery/features/order_details/presentation/manager/order_details_cubit.dart';
import 'package:zadana_delivery/features/order_details/presentation/manager/order_details_event.dart';
import 'package:zadana_delivery/features/order_details/presentation/manager/order_details_state.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_loading_view.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_screen_view.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_status_dialog.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_support/order_support_composer.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_support/order_support_mode.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({
    super.key,
    required this.order,
    required this.driverLocation,
    this.startAccepted = false,
    this.initialSuccessMessage,
  });

  final DriverOrderPreview order;
  final LatLng driverLocation;
  final bool startAccepted;
  final String? initialSuccessMessage;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late final OrderDetailsController _controller;
  late final OrderDetailsCubit _cubit;
  bool _didInitializeController = false;
  bool _isPickupOtpSheetOpen = false;
  bool _isCustomerOtpSheetOpen = false;
  bool _isSupportComposerOpen = false;
  bool _isBlockingDialogOpen = false;
  bool _hasOpenedDeliverySuccess = false;
  BuildContext? _pickupOtpSheetContext;
  String? _pendingCompletionMessage;
  String? _pendingSupportNotificationMessage;

  String get _itemsNote =>
      widget.order.packageNote ??
      context.localization.order_details_package_note_fallback;

  Future<void> _openDeliverySuccessScreen() async {
    if (_hasOpenedDeliverySuccess) return;
    _hasOpenedDeliverySuccess = true;
    final message = (_pendingCompletionMessage ?? '').trim();
    _pendingCompletionMessage = null;
    if (!mounted) return;
    await context.pushReplacementNamed(
      AppRoutes.orderDeliverySuccess,
      rootNavigator: true,
      arguments: {if (message.isNotEmpty) 'message': message},
    );
  }

  @override
  void initState() {
    super.initState();
    _cubit = getIt<OrderDetailsCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final message = widget.initialSuccessMessage?.trim() ?? '';
      if (!mounted || message.isEmpty) return;
      CustomSnackbar.showSuccess(context: context, message: message);
    });
    unawaited(
      _cubit.doIntent(
        OrderDetailsActivateRealtimeEvent(
          assignmentId: widget.order.id,
          orderId: widget.order.orderId,
        ),
      ),
    );
    unawaited(
      _cubit.doIntent(OrderDetailsLoadAssignmentEvent(widget.order.id)),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitializeController) return;

    _controller = OrderDetailsController(
      order: widget.order,
      driverLocation: widget.driverLocation,
      startAccepted: widget.startAccepted,
      storeMarkerLabel: context.localization.order_details_store_label,
      customerMarkerLabel: context.localization.completed_orders_customer_label,
    );
    _didInitializeController = true;
  }

  @override
  void dispose() {
    _cubit.close();
    if (_didInitializeController) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<bool> _showDecision({
    required String title,
    required String message,
    required String confirmLabel,
    required Color confirmColor,
  }) async {
    final confirmed = await OrderDetailsSheets.showConfirmationDialog(
      context: context,
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      confirmColor: confirmColor,
    );
    return confirmed;
  }

  void _acceptOrder() async {
    final locale = context.localization;
    final confirmed = await _showDecision(
      title: locale.order_details_accept_dialog_title,
      message: locale.order_details_accept_dialog_message(widget.order.title),
      confirmLabel: locale.order_details_accept_dialog_confirm,
      confirmColor: context.colorScheme.primary,
    );
    if (!confirmed || !mounted) return;

    final accepted = await _cubit.doIntent(
      OrderDetailsAcceptOfferEvent(_controller.assignmentId),
    );
    if (!mounted || !accepted) return;

    _controller.updateStage(OrderDeliveryStage.accepted);
  }

  Future<void> _rejectOrder() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => DriverHomeRejectOrderDialog(
        order: widget.order,
        dialogContext: dialogContext,
      ),
    );
    if (!mounted || confirmed != true) return;

    final success = await _cubit.doIntent(
      OrderDetailsRejectOfferEvent(_controller.assignmentId),
    );
    if (!mounted || !success) return;

    Navigator.of(context).pop('reject');
  }

  void _confirmPickup() async {
    final locale = context.localization;
    final confirmed = await OrderDetailsSheets.showConfirmationDialog(
      context: context,
      title: locale.order_details_pickup_dialog_title,
      message: locale.order_details_pickup_dialog_message(
        widget.order.vendorName,
      ),
      confirmLabel: locale.order_details_pickup_dialog_confirm,
      confirmColor: context.colorScheme.secondary,
    );
    if (!confirmed || !mounted) return;

    final orderId = _controller.order.orderId.trim();
    if (orderId.isEmpty) return;

    final success = await _cubit.doIntent(
      OrderDetailsMarkPickedUpEvent(orderId),
    );
    if (!mounted || !success) return;
    await _refreshOrderDetails(silent: true);
  }

  void _showItems() => OrderDetailsSheets.showOrderItemsSheet(
    context: context,
    items: _controller.orderItems,
    packageNote: _itemsNote,
  );

  Future<void> _showPickupOtp() async {
    _isPickupOtpSheetOpen = true;
    _pickupOtpSheetContext = null;
    await OrderDetailsSheets.showPickupOtpSheet(
      context: context,
      otp: _controller.pickupOtpCode ?? '',
      onSubmit: _controller.canVerifyPickupOtp ? _verifyPickupOtp : null,
      onResend: _resendPickupOtp,
      onConfirm: _controller.canMarkPickedUp ? _confirmPickup : null,
      onSheetContextReady: (sheetContext) {
        _pickupOtpSheetContext = sheetContext;
      },
    );
    _isPickupOtpSheetOpen = false;
    _pickupOtpSheetContext = null;
  }

  Future<void> _showCustomerOtp() async {
    if (!_controller.deliveryOtpRequired) {
      await _deliverOrder();
      return;
    }
    setState(() => _isCustomerOtpSheetOpen = true);
    try {
      await OrderDetailsSheets.showCustomerOtpSheet(
        context: context,
        onSubmit: _verifyDeliveryOtp,
        onResend: _resendDeliveryOtp,
        onVerified: _openDeliverySuccessScreen,
      );
    } finally {
      if (mounted) {
        setState(() => _isCustomerOtpSheetOpen = false);
      } else {
        _isCustomerOtpSheetOpen = false;
      }
    }
  }

  void _handlePickupAction() {
    if (_controller.canVerifyPickupOtp || _controller.canShowPickupOtpSheet) {
      _showPickupOtp();
      return;
    }
    if (_controller.canMarkPickedUp || !_controller.pickupOtpRequired) {
      _confirmPickup();
      return;
    }
  }

  void _call(String number) async {
    if (await OrderDetailsLauncher.callNumber(number) || !mounted) return;
    OrderDetailsLauncher.showFailure(
      context,
      context.localization.order_details_call_failure,
    );
  }

  void _route(LatLng destination, String label) async {
    if (await OrderDetailsLauncher.openRoute(
          destination: destination,
          destinationLabel: label,
        ) ||
        !mounted) {
      return;
    }
    OrderDetailsLauncher.showFailure(
      context,
      context.localization.order_details_maps_failure,
    );
  }

  void _finish() => Navigator.of(context).pop(<String, dynamic>{
    'action': _controller.stage == OrderDeliveryStage.pending
        ? 'reject'
        : 'accept',
  });

  Future<void> _arrivedAtVendor() async {
    final locale = context.localization;
    final confirmed = await OrderDetailsSheets.showConfirmationDialog(
      context: context,
      title: locale.order_details_arrived_vendor_dialog_title,
      message: locale.order_details_arrived_vendor_dialog_message(
        widget.order.vendorName,
      ),
      confirmLabel: locale.order_details_arrived_vendor_dialog_confirm,
      confirmColor: context.colorScheme.secondary,
    );
    if (!confirmed || !mounted) return;

    final orderId = _controller.order.orderId.trim();
    if (orderId.isEmpty) return;

    final success = await _cubit.doIntent(
      OrderDetailsUpdateArrivalStateEvent(
        orderId,
        arrivalState: 'arrived_at_vendor',
      ),
    );
    if (!mounted || !success) return;
    _controller.applyLocalStageTransition(OrderDeliveryStage.arrivedAtVendor);
    _showStatusChangeToast();
  }

  Future<void> _startDelivery() async {
    final locale = context.localization;
    final confirmed = await OrderDetailsSheets.showConfirmationDialog(
      context: context,
      title: locale.order_details_start_delivery_dialog_title,
      message: locale.order_details_start_delivery_dialog_message,
      confirmLabel: locale.order_details_start_delivery_dialog_confirm,
      confirmColor: context.colorScheme.secondary,
    );
    if (!confirmed || !mounted) return;

    final orderId = _controller.order.orderId.trim();
    if (orderId.isEmpty) return;

    final success = await _cubit.doIntent(
      OrderDetailsMarkOnTheWayEvent(orderId),
    );
    if (!mounted || !success) return;
    _controller.applyLocalStageTransition(OrderDeliveryStage.onTheWay);
    _showStatusChangeToast();
  }

  Future<void> _arrivedAtCustomer() async {
    final locale = context.localization;
    final confirmed = await OrderDetailsSheets.showConfirmationDialog(
      context: context,
      title: locale.order_details_arrived_customer_dialog_title,
      message: locale.order_details_arrived_customer_dialog_message,
      confirmLabel: locale.order_details_arrived_customer_dialog_confirm,
      confirmColor: context.colorScheme.primary,
    );
    if (!confirmed || !mounted) return;

    final orderId = _controller.order.orderId.trim();
    if (orderId.isEmpty) return;

    final success = await _cubit.doIntent(
      OrderDetailsUpdateArrivalStateEvent(
        orderId,
        arrivalState: 'arrived_at_customer',
      ),
    );
    if (!mounted || !success) return;
    _controller.markArrivedAtCustomer();
    _showStatusChangeToast();
  }

  Future<void> _deliverOrder() async {
    final locale = context.localization;
    final confirmed = await OrderDetailsSheets.showConfirmationDialog(
      context: context,
      title: locale.order_details_delivered_dialog_title,
      message: locale.order_details_delivered_dialog_message,
      confirmLabel: locale.order_details_delivered_dialog_confirm,
      confirmColor: context.colorScheme.primary,
    );
    if (!confirmed || !mounted) return;

    final orderId = _controller.order.orderId.trim();
    if (orderId.isEmpty) return;

    final success = await _cubit.doIntent(
      OrderDetailsMarkDeliveredEvent(orderId),
    );
    if (!mounted || !success) return;
    _pendingCompletionMessage = _cubit.state.notificationMessage?.trim();
    await _openDeliverySuccessScreen();
  }

  Future<bool> _verifyDeliveryOtp(String otpCode) async {
    final assignmentId = _controller.assignmentId.trim();
    if (assignmentId.isEmpty) return false;

    final success = await _cubit.doIntent(
      OrderDetailsVerifyDeliveryOtpEvent(assignmentId, otpCode: otpCode),
    );
    if (!mounted || !success) return false;

    _pendingCompletionMessage = _cubit.state.notificationMessage?.trim();
    return true;
  }

  Future<bool> _verifyPickupOtp(String otpCode) async {
    final assignmentId = _controller.assignmentId.trim();
    if (assignmentId.isEmpty) return false;

    final success = await _cubit.doIntent(
      OrderDetailsVerifyPickupOtpEvent(assignmentId, otpCode: otpCode),
    );
    if (!mounted || !success) return false;

    await _refreshOrderDetails(silent: true);
    return true;
  }

  Future<bool> _resendDeliveryOtp() async {
    final assignmentId = _controller.assignmentId.trim();
    if (assignmentId.isEmpty) return false;

    final success = await _cubit.doIntent(
      OrderDetailsResendDeliveryOtpEvent(assignmentId),
    );
    if (!mounted || !success) return false;

    await _refreshOrderDetails(silent: true);
    return true;
  }

  Future<bool> _resendPickupOtp() async {
    final assignmentId = _controller.assignmentId.trim();
    if (assignmentId.isEmpty) return false;

    final wasShowingPickupCode =
        (_controller.pickupOtpCode ?? '').trim().isNotEmpty;
    final success = await _cubit.doIntent(
      OrderDetailsResendPickupOtpEvent(assignmentId),
    );
    if (!mounted || !success) return false;

    await _refreshOrderDetails(silent: true);
    final details = _cubit.state.details;
    if (details != null) {
      _controller.applyAssignmentDetails(details);
    }

    if (wasShowingPickupCode && _isPickupOtpSheetOpen) {
      final sheetContext = _pickupOtpSheetContext;
      if (sheetContext != null && sheetContext.mounted) {
        Navigator.of(sheetContext).pop();
      }

      unawaited(
        Future<void>.delayed(const Duration(milliseconds: 160), () async {
          if (!mounted) return;
          await _showPickupOtp();
        }),
      );
    }

    return true;
  }

  void _dismissPickupOtpSheetIfNeeded() {
    if (!_isPickupOtpSheetOpen) return;
    if (_controller.stage == OrderDeliveryStage.arrivedAtVendor) return;

    final sheetContext = _pickupOtpSheetContext;
    if (sheetContext != null && sheetContext.mounted) {
      Navigator.of(sheetContext).pop();
      return;
    }

    if (mounted) {
      Navigator.of(context).maybePop();
    }
  }

  Future<void> _refreshOrderDetails({bool silent = false}) async {
    await _cubit.doIntent(
      OrderDetailsLoadAssignmentEvent(widget.order.id, silent: silent),
    );
  }

  void _showStatusChangeToast() {
    final message = _cubit.state.notificationMessage?.trim() ?? '';
    showOrderStatusChangeToast(context, serverMessage: message);
    if (message.isNotEmpty) {
      unawaited(_cubit.doIntent(const OrderDetailsConsumeNotificationEvent()));
    }
  }

  Future<void> _showBlockingOrderDialog(String message) async {
    if (_isBlockingDialogOpen) return;
    _isBlockingDialogOpen = true;
    try {
      await showOrderStatusBlockingDialog(context, message: message);
    } finally {
      _isBlockingDialogOpen = false;
    }
  }

  Future<void> _openSupportComposer() async {
    _isSupportComposerOpen = true;
    final type = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      showDragHandle: false,
      builder: (sheetContext) {
        final mediaQuery = MediaQuery.of(sheetContext);
        return AnimatedPadding(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
          child: FractionallySizedBox(
            heightFactor: 0.60,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(sheetContext).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 28,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  child: OrderSupportComposer(
                    loadingContext: context,
                    onSubmit: (mode, reasonCode, message, attachments) async {
                      final orderId = _controller.order.orderId.trim();
                      if (orderId.isEmpty) return false;
                      final request = DriverSupportCaseMessageRequestEntity(
                        reasonCode: reasonCode,
                        message: message,
                        attachments: attachments,
                      );
                      final success = switch (mode) {
                        OrderSupportMode.issue => _cubit.doIntent(
                          OrderDetailsReportIssueEvent(
                            orderId,
                            request: request,
                          ),
                        ),
                        OrderSupportMode.dispute => _cubit.doIntent(
                          OrderDetailsCreateDisputeEvent(
                            orderId,
                            request: request,
                          ),
                        ),
                      };
                      return success;
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    _isSupportComposerOpen = false;
    final queuedSupportNotification =
        _pendingSupportNotificationMessage?.trim();
    if ((queuedSupportNotification ?? '').isNotEmpty && mounted) {
      CustomSnackbar.showSuccess(
        context: context,
        message: queuedSupportNotification!,
      );
      _pendingSupportNotificationMessage = null;
      unawaited(_cubit.doIntent(const OrderDetailsConsumeNotificationEvent()));
    }
    if (!mounted || type == null) return;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading ||
            previous.isActionLoading != current.isActionLoading ||
            previous.failure != current.failure,
        listenWhen: (previous, current) =>
            previous.details != current.details ||
            previous.failure != current.failure ||
            previous.notificationMessage != current.notificationMessage ||
            previous.blockingMessage != current.blockingMessage ||
            previous.shouldCloseScreen != current.shouldCloseScreen,
        listener: (context, state) {
          final details = state.details;
          if (details != null) {
            final wasDelivered =
                _controller.stage == OrderDeliveryStage.delivered;
            _controller.applyAssignmentDetails(details);
            _dismissPickupOtpSheetIfNeeded();
            final isDelivered =
                _controller.stage == OrderDeliveryStage.delivered;
            if (!wasDelivered && isDelivered && !_hasOpenedDeliverySuccess) {
              final notificationMessage = state.notificationMessage?.trim();
              if ((notificationMessage ?? '').isNotEmpty) {
                _pendingCompletionMessage = notificationMessage;
              }
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                unawaited(_openDeliverySuccessScreen());
              });
            }
          }

          final notificationMessage = state.notificationMessage;
          if ((notificationMessage ?? '').trim().isNotEmpty) {
            if (_isSupportComposerOpen) {
              _pendingSupportNotificationMessage = notificationMessage!.trim();
              return;
            }
            CustomSnackbar.showInfo(
              context: context,
              message: notificationMessage!.trim(),
            );
            unawaited(
              _cubit.doIntent(const OrderDetailsConsumeNotificationEvent()),
            );
          }

          final blockingMessage = state.blockingMessage?.trim() ?? '';
          if (state.shouldCloseScreen && blockingMessage.isNotEmpty) {
            final navigator = Navigator.of(context);
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (!mounted) return;
              await _showBlockingOrderDialog(blockingMessage);
              if (!mounted) return;
              await _cubit.doIntent(
                const OrderDetailsConsumeBlockingMessageEvent(),
              );
              if (!mounted) return;
              navigator.maybePop();
            });
          }

          final exception = state.failure?.asException;
          if (!state.isLoading &&
              exception != null &&
              (_isSupportComposerOpen || exception.errorType.showSnackBar)) {
            CustomSnackbar.showError(
              context: context,
              message: ErrorMessagePresenter.snackBarMessage(
                context,
                exception,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.details == null) {
            return OrderDetailsLoadingView(onBack: context.pop);
          }

          final exception = state.failure?.asException;
          if (!state.isLoading &&
              exception != null &&
              exception.errorType.showFullScreen &&
              state.details == null) {
            return Scaffold(
              backgroundColor: context.colorScheme.surface,
              appBar: CustomAppBar.modern(
                title: context.localization.order_details_title,
                backgroundColor: context.colorScheme.surface,
                onBackPressed: context.pop,
              ),
              body: SafeArea(
                child: ApiErrorWidget(
                  exception: exception,
                  onRetry: _refreshOrderDetails,
                  onGoBack: _cubit.clearError,
                ),
              ),
            );
          }

          return OrderDetailsScreenView(
            controller: _controller,
            isActionLoading: state.isActionLoading &&
                !_isCustomerOtpSheetOpen &&
                !_isPickupOtpSheetOpen,
            onBack: context.pop,
            onAcceptOrder: _acceptOrder,
            onRejectOrder: _rejectOrder,
            onArrivedAtVendor: _arrivedAtVendor,
            onShowPickupOtp: _handlePickupAction,
            onArrivedAtCustomer: _arrivedAtCustomer,
            onShowCustomerOtp: _showCustomerOtp,
            onStartDelivery: _startDelivery,
            onShowItems: _showItems,
            onCallStore: () => _call(_controller.storePhone),
            onCallCustomer: () => _call(_controller.customerPhone),
            onOpenStoreRoute: () => _route(
              _controller.storeLocation,
              _controller.order.pickupAddress,
            ),
            onOpenCustomerRoute: () => _route(
              _controller.customerLocation,
              _controller.order.deliveryAddress,
            ),
            onFinish: _finish,
            onRefresh: _refreshOrderDetails,
            onOpenSupportComposer: _openSupportComposer,
            onResendPickupOtp: _resendPickupOtp,
          );
        },
      ),
    );
  }
}
