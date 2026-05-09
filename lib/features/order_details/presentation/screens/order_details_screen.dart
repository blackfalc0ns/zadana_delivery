import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zadana_delivery/config/routing/app_routes.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_presentation.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/services/file_upload_service.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/core/widgets/loading/loading_overlay.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_reject_order_dialog.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_attachment_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_message_request_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_reason_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/usecase/get_driver_support_reasons_usecase.dart';
import 'package:zadana_delivery/features/order_details/presentation/controllers/order_details_controller.dart';
import 'package:zadana_delivery/features/order_details/presentation/helpers/order_details_launcher.dart';
import 'package:zadana_delivery/features/order_details/presentation/helpers/order_details_sheets.dart';
import 'package:zadana_delivery/features/order_details/presentation/manager/order_details_cubit.dart';
import 'package:zadana_delivery/features/order_details/presentation/manager/order_details_event.dart';
import 'package:zadana_delivery/features/order_details/presentation/manager/order_details_state.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_loading_view.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_screen_view.dart';

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
    unawaited(_cubit.doIntent(const OrderDetailsDeactivateRealtimeEvent()));
    _cubit.close();
    if (_didInitializeController) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _showDecision({
    required String title,
    required String message,
    required String confirmLabel,
    required Color confirmColor,
    required OrderDeliveryStage nextStage,
  }) async {
    final confirmed = await OrderDetailsSheets.showConfirmationDialog(
      context: context,
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      confirmColor: confirmColor,
    );
    if (confirmed) _controller.updateStage(nextStage);
  }

  void _acceptOrder() async {
    final locale = context.localization;
    await _showDecision(
      title: locale.order_details_accept_dialog_title,
      message: locale.order_details_accept_dialog_message(widget.order.title),
      confirmLabel: locale.order_details_accept_dialog_confirm,
      confirmColor: context.colorScheme.primary,
      nextStage: OrderDeliveryStage.accepted,
    );
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
    await _refreshOrderDetails(silent: true);
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

    final wasShowingPickupCode = (_controller.pickupOtpCode ?? '')
        .trim()
        .isNotEmpty;
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

  String _supportStatusLabel(bool isArabic) {
    return switch (_controller.stage) {
      OrderDeliveryStage.pending => isArabic ? 'قيد الانتظار' : 'Pending',
      OrderDeliveryStage.accepted => isArabic ? 'قيد التنفيذ' : 'In progress',
      OrderDeliveryStage.arrivedAtVendor =>
        isArabic ? 'تم الوصول للمتجر' : 'Arrived at store',
      OrderDeliveryStage.pickedUp => isArabic ? 'تم الاستلام' : 'Picked up',
      OrderDeliveryStage.onTheWay => isArabic ? 'في الطريق' : 'On the way',
      OrderDeliveryStage.delivered => isArabic ? 'تم التسليم' : 'Delivered',
    };
  }

  String _supportTotalAmountText(bool isArabic) {
    final amount = _controller.order.totalAmount.toStringAsFixed(2);
    return isArabic ? 'ريال $amount' : '$amount SAR';
  }

  Future<void> _openSupportComposer() async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
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
                  child: _OrderSupportComposer(
                    isArabic: isArabic,
                    loadingContext: context,
                    statusLabel: _supportStatusLabel(isArabic),
                    totalAmountText: _supportTotalAmountText(isArabic),
                    onSubmit: (mode, reasonCode, message, attachments) async {
                      final orderId = _controller.order.orderId.trim();
                      if (orderId.isEmpty) return false;
                      final request = DriverSupportCaseMessageRequestEntity(
                        reasonCode: reasonCode,
                        message: message,
                        attachments: attachments,
                      );
                      final success = switch (mode) {
                        _OrderSupportMode.issue => _cubit.doIntent(
                          OrderDetailsReportIssueEvent(
                            orderId,
                            request: request,
                          ),
                        ),
                        _OrderSupportMode.dispute => _cubit.doIntent(
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
    final queuedSupportNotification = _pendingSupportNotificationMessage
        ?.trim();
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
            previous.notificationMessage != current.notificationMessage,
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
            isActionLoading:
                state.isActionLoading &&
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
          );
        },
      ),
    );
  }
}

class _SupportModeTile extends StatelessWidget {
  const _SupportModeTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? selectedColor.withValues(alpha: 0.14)
                : scheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? selectedColor.withValues(alpha: 0.55)
                  : scheme.outlineVariant.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: isSelected
                      ? selectedColor.withValues(alpha: 0.16)
                      : scheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? selectedColor : scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: isSelected ? selectedColor : scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportAttachmentPreview extends StatelessWidget {
  const _SupportAttachmentPreview({
    required this.imagePath,
    required this.onRemove,
  });

  final String imagePath;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.22),
            ),
            image: DecorationImage(
              image: FileImage(File(imagePath)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: Material(
            color: scheme.error,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onRemove,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.close_rounded,
                  size: 12,
                  color: scheme.onError,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum _OrderSupportMode { issue, dispute }

extension on _OrderSupportMode {
  String get reasonType =>
      this == _OrderSupportMode.issue ? 'report' : 'dispute';
}

class _OrderSupportComposer extends StatefulWidget {
  const _OrderSupportComposer({
    required this.isArabic,
    required this.loadingContext,
    required this.statusLabel,
    required this.totalAmountText,
    required this.onSubmit,
  });

  final bool isArabic;
  final BuildContext loadingContext;
  final String statusLabel;
  final String totalAmountText;
  final Future<bool> Function(
    _OrderSupportMode mode,
    String reasonCode,
    String message,
    List<DriverSupportAttachmentEntity> attachments,
  )
  onSubmit;

  @override
  State<_OrderSupportComposer> createState() => _OrderSupportComposerState();
}

class _OrderSupportComposerState extends State<_OrderSupportComposer> {
  late final TextEditingController _messageController;
  final ImagePicker _imagePicker = getIt<ImagePicker>();
  final FileUploadService _fileUploadService = getIt<FileUploadService>();
  final GetDriverSupportReasonsUseCase _getSupportReasonsUseCase =
      getIt<GetDriverSupportReasonsUseCase>();
  final Map<String, List<DriverSupportReasonEntity>> _reasonsCache =
      <String, List<DriverSupportReasonEntity>>{};
  _OrderSupportMode _mode = _OrderSupportMode.issue;
  String? _selectedReasonCode;
  bool _isSubmitting = false;
  bool _isLoadingReasons = false;
  String? _reasonsErrorMessage;
  List<XFile> _selectedImages = const <XFile>[];

  String _text(String ar, String en) => widget.isArabic ? ar : en;
  List<DriverSupportReasonEntity> get _reasonOptions =>
      _reasonsCache[_mode.reasonType] ?? const <DriverSupportReasonEntity>[];
  DriverSupportReasonEntity? get _selectedReason {
    final code = _selectedReasonCode;
    if (code == null) return null;
    for (final option in _reasonOptions) {
      if (option.code == code) return option;
    }
    return null;
  }

  bool get _requiresNote => _selectedReason?.requiresNote ?? false;
  bool get _hasReasons => _reasonOptions.isNotEmpty;
  bool get _canSubmit => !_isSubmitting && !_isLoadingReasons && _hasReasons;

  String _reasonLabel(DriverSupportReasonEntity option) =>
      widget.isArabic ? option.labelAr : option.labelEn;

  String get _messageLabel => _requiresNote
      ? _text('الملاحظة المطلوبة', 'Required note')
      : _text('ملاحظات إضافية', 'Additional note');

  String get _submitLabel => _mode == _OrderSupportMode.issue
      ? _text('إرسال الحالة', 'Send case')
      : _text('إرسال النزاع', 'Send dispute');

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    unawaited(_loadReasonsForMode(_mode));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadReasonsForMode(
    _OrderSupportMode mode, {
    bool forceRefresh = false,
  }) async {
    final type = mode.reasonType;
    if (!forceRefresh && _reasonsCache.containsKey(type)) {
      final options = _reasonsCache[type]!;
      if (mounted) {
        setState(() {
          _reasonsErrorMessage = null;
          if (mode == _mode) {
            _selectedReasonCode = _resolveNextSelectedReasonCode(
              options,
              _selectedReasonCode,
            );
          }
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingReasons = true;
        _reasonsErrorMessage = null;
        if (mode == _mode) {
          _selectedReasonCode = null;
        }
      });
    }

    final result = await _getSupportReasonsUseCase.call(type);
    if (!mounted) return;

    switch (result) {
      case ApiSuccessResult<List<DriverSupportReasonEntity>>():
        final options = result.data;
        setState(() {
          _isLoadingReasons = false;
          _reasonsErrorMessage = null;
          _reasonsCache[type] = options;
          if (mode == _mode) {
            _selectedReasonCode = _resolveNextSelectedReasonCode(
              options,
              _selectedReasonCode,
            );
          }
        });
      case ApiErrorResult<List<DriverSupportReasonEntity>>():
        setState(() {
          _isLoadingReasons = false;
          _reasonsErrorMessage = ErrorMessagePresenter.snackBarMessage(
            context,
            result.failure.asException,
          );
        });
    }
  }

  String? _resolveNextSelectedReasonCode(
    List<DriverSupportReasonEntity> options,
    String? currentCode,
  ) {
    if (options.isEmpty) return null;
    for (final option in options) {
      if (option.code == currentCode) return currentCode;
    }
    return options.first.code;
  }

  void _changeMode(_OrderSupportMode mode) {
    if (_isSubmitting || mode == _mode) return;
    setState(() {
      _mode = mode;
      _selectedReasonCode = null;
      _reasonsErrorMessage = null;
    });
    unawaited(_loadReasonsForMode(mode));
  }

  Future<void> _submit() async {
    final reasonCode = (_selectedReasonCode ?? '').trim();
    final message = _messageController.text.trim();
    if (_isLoadingReasons) return;
    if ((_reasonsErrorMessage ?? '').trim().isNotEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: _text(
          'تعذر تحميل الأسباب حالياً. أعد المحاولة أولاً.',
          'Unable to load reasons right now. Please retry first.',
        ),
      );
      return;
    }
    if (!_hasReasons) {
      CustomSnackbar.showError(
        context: context,
        message: _text(
          'لا توجد أسباب متاحة حالياً لهذا النوع.',
          'No reasons are available for this type right now.',
        ),
      );
      return;
    }
    if (reasonCode.isEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: _text('اختر السبب', 'Choose a reason'),
      );
      return;
    }
    if (_requiresNote && message.isEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: _text(
          'اكتب الرسالة لتوضيح السبب',
          'Enter a message to clarify the reason',
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    LoadingOverlay.show(widget.loadingContext);
    try {
      final attachments = await _uploadSelectedImages();
      final success = await widget.onSubmit(
        _mode,
        reasonCode,
        message,
        attachments,
      );
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      if (success) {
        Navigator.of(context).pop(_mode.name);
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      CustomSnackbar.showError(
        context: context,
        message: error is Exception
            ? error.toString().replaceFirst('Exception: ', '')
            : _text(
                '\u062a\u0639\u0630\u0631 \u0631\u0641\u0639 \u0627\u0644\u0635\u0648\u0631 \u0627\u0644\u0645\u0631\u0641\u0642\u0629. \u062d\u0627\u0648\u0644 \u0645\u0631\u0629 \u0623\u062e\u0631\u0649.',
                'Unable to upload the selected images. Please try again.',
              ),
      );
    } finally {
      if (widget.loadingContext.mounted) {
        LoadingOverlay.hide(widget.loadingContext);
      }
    }
  }

  Future<void> _pickImages() async {
    if (_isSubmitting) return;

    try {
      final images = await _imagePicker.pickMultiImage(imageQuality: 82);
      if (!mounted || images.isEmpty) return;
      setState(() {
        final existingPaths = _selectedImages.map((item) => item.path).toSet();
        final merged = List<XFile>.from(_selectedImages);
        for (final image in images) {
          if (existingPaths.add(image.path)) {
            merged.add(image);
          }
        }
        _selectedImages = merged;
      });
    } catch (_) {
      if (!mounted) return;
      CustomSnackbar.showError(
        context: context,
        message: _text(
          'تعذر فتح منتقي الصور. حاول مرة أخرى.',
          'Unable to open the image picker. Please try again.',
        ),
      );
    }
  }

  Future<List<DriverSupportAttachmentEntity>> _uploadSelectedImages() async {
    if (_selectedImages.isEmpty) return const <DriverSupportAttachmentEntity>[];

    final attachments = <DriverSupportAttachmentEntity>[];
    for (final image in _selectedImages) {
      final url = await _fileUploadService.uploadFile(
        image.path,
        directory: DriverUploadDirectory.proofs,
      );
      final file = File(image.path);
      final fileName = file.uri.pathSegments.isEmpty
          ? 'attachment.jpg'
          : file.uri.pathSegments.last;
      attachments.add(
        DriverSupportAttachmentEntity(fileName: fileName, fileUrl: url),
      );
    }
    return attachments;
  }

  void _removeImage(XFile image) {
    if (_isSubmitting) return;
    setState(() {
      _selectedImages = _selectedImages
          .where((item) => item.path != image.path)
          .toList(growable: false);
    });
  }

  Widget _buildReasonField(ColorScheme scheme) {
    if (_isLoadingReasons) {
      return Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.28),
          ),
        ),
        child: const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2.2),
        ),
      );
    }

    if ((_reasonsErrorMessage ?? '').trim().isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _reasonsErrorMessage!,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: scheme.error),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: OutlinedButton.icon(
              onPressed: _isSubmitting
                  ? null
                  : () => _loadReasonsForMode(_mode, forceRefresh: true),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(
                _text(
                  '\u0625\u0639\u0627\u062f\u0629 \u0627\u0644\u0645\u062d\u0627\u0648\u0644\u0629',
                  'Retry',
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (_reasonOptions.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.28),
          ),
        ),
        child: Text(
          _text(
            'لا توجد أسباب متاحة حالياً. حاول مرة أخرى لاحقاً.',
            'No reasons are available right now. Please try again later.',
          ),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
      );
    }

    return DropdownButtonFormField<String>(
      initialValue: _selectedReasonCode,
      borderRadius: BorderRadius.circular(12),
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: scheme.onSurfaceVariant,
        size: 18,
      ),
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
      decoration: InputDecoration(
        labelText: _text('السبب', 'Reason'),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: _text('السبب', 'Reason'),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.28),
          ),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: _reasonOptions
          .map(
            (option) => DropdownMenuItem<String>(
              value: option.code,
              child: Text(
                _reasonLabel(option),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(growable: false),
      onChanged: _isSubmitting || _reasonOptions.isEmpty
          ? null
          : (value) {
              setState(() {
                _selectedReasonCode = value;
              });
            },
    );
  }

  Widget _buildAttachmentsSection(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _isSubmitting ? null : _pickImages,
            iconAlignment: IconAlignment.end,
            icon: const Icon(Icons.image_outlined, size: 22),
            label: Text(
              _selectedImages.isEmpty
                  ? _text('إرفاق ملفات', 'Attach files')
                  : _text('إرفاق ملفات أخرى', 'Attach more files'),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: scheme.primary,
              minimumSize: const Size.fromHeight(48),
              side: BorderSide(color: scheme.primary, width: 1.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        if (_selectedImages.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _selectedImages
                .map(
                  (image) => _SupportAttachmentPreview(
                    imagePath: image.path,
                    onRemove: () => _removeImage(image),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ],
    );
  }

  // Widget _buildSummaryStrip(ColorScheme scheme) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //     decoration: BoxDecoration(
  //       color: scheme.surface,
  //       borderRadius: BorderRadius.circular(18),
  //       border: Border.all(
  //         color: scheme.outlineVariant.withValues(alpha: 0.18),
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: scheme.shadow.withValues(alpha: 0.04),
  //           blurRadius: 18,
  //           offset: const Offset(0, 8),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Text(
  //             widget.totalAmountText,
  //             style: Theme.of(context).textTheme.titleMedium?.copyWith(
  //               color: scheme.primary,
  //               fontWeight: FontWeight.w800,
  //             ),
  //           ),
  //         ),
  //         Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //           decoration: BoxDecoration(
  //             color: const Color(0xFFFCECD8),
  //             borderRadius: BorderRadius.circular(999),
  //           ),
  //           child: Text(
  //             widget.statusLabel,
  //             style: Theme.of(context).textTheme.titleMedium?.copyWith(
  //               color: const Color(0xFFDD8A1F),
  //               fontWeight: FontWeight.w800,
  //               fontSize: 13,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 54,
              height: 5,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: scheme.outlineVariant.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Center(
            child: Text(
              _text('إنشاء حالة دعم', 'Create support case'),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 17,
                letterSpacing: -0.3,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              _text(
                'اشرح المشكلة وأرفق الملفات قبل إرسال الحالة.',
                'Describe the issue and attach files before sending the case.',
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.4,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 14),
          //   _buildSummaryStrip(scheme),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: _SupportModeTile(
                  title: _text('\u0645\u0634\u0643\u0644\u0629', 'Issue'),
                  subtitle: _text(
                    '\u062a\u0634\u063a\u064a\u0644\u064a',
                    'Operational',
                  ),
                  icon: Icons.report_problem_outlined,
                  isSelected: _mode == _OrderSupportMode.issue,
                  selectedColor: scheme.primary,
                  onTap: _isSubmitting
                      ? null
                      : () => _changeMode(_OrderSupportMode.issue),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SupportModeTile(
                  title: _text('\u0646\u0632\u0627\u0639', 'Dispute'),
                  subtitle: _text(
                    '\u0627\u0639\u062a\u0631\u0627\u0636',
                    'Objection',
                  ),
                  icon: Icons.gavel_rounded,
                  isSelected: _mode == _OrderSupportMode.dispute,
                  selectedColor: scheme.secondary,
                  onTap: _isSubmitting
                      ? null
                      : () => _changeMode(_OrderSupportMode.dispute),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildReasonField(scheme),
          const SizedBox(height: 12),
          TextField(
            controller: _messageController,
            maxLines: 3,
            minLines: 3,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              labelText: _messageLabel,
              alignLabelWithHint: true,
              hintText: _text('اكتب ما حدث', 'Write what happened'),
              hintStyle: theme.textTheme.titleMedium?.copyWith(
                color: scheme.onSurfaceVariant.withValues(alpha: 0.48),
                fontWeight: FontWeight.w500,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: scheme.outlineVariant.withValues(alpha: 0.28),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              helperText: _requiresNote
                  ? _text(
                      'هذا السبب يتطلب كتابة ملاحظة قبل الإرسال.',
                      'This reason requires a note before submission.',
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 14),
          _buildAttachmentsSection(context),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppButton.outlined(
                  text: _text('إلغاء', 'Cancel'),
                  height: 50,
                  borderRadius: 12,
                  color: scheme.outline,
                  textColor: scheme.onSurface,
                  onPressed: _isSubmitting
                      ? null
                      : () => Navigator.of(context).maybePop(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton.filled(
                  text: _submitLabel,
                  height: 50,
                  borderRadius: 12,
                  color: scheme.primary,
                  textColor: Colors.white,
                  onPressed: _canSubmit ? _submit : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
