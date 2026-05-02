import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_presentation.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';
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
  BuildContext? _pickupOtpSheetContext;
  String? _pendingCompletionMessage;

  String get _itemsNote =>
      widget.order.packageNote ??
      context.localization.order_details_package_note_fallback;

  void _popWithResult({required String action, String? message}) {
    Navigator.of(context).pop(<String, dynamic>{
      'action': action,
      if ((message ?? '').trim().isNotEmpty) 'message': message!.trim(),
    });
  }

  void _completeFlowAndReturnHome() {
    final message = (_pendingCompletionMessage ?? '').trim();
    _popWithResult(action: 'accept', message: message.isEmpty ? null : message);
    _pendingCompletionMessage = null;
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
    await OrderDetailsSheets.showCustomerOtpSheet(
      context: context,
      onSubmit: _verifyDeliveryOtp,
      onSuccess: () {
        if (!mounted) return;
        _completeFlowAndReturnHome();
      },
    );
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
    _completeFlowAndReturnHome();
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

  Future<void> _openSupportComposer() async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final type = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
          ),
          child: _OrderSupportComposer(
            isArabic: isArabic,
            onSubmit: (mode, reasonCode, message) async {
              final orderId = _controller.order.orderId.trim();
              if (orderId.isEmpty) return false;
              final request = DriverSupportCaseMessageRequestEntity(
                reasonCode: reasonCode,
                message: message,
              );
              final success = switch (mode) {
                _OrderSupportMode.issue => _cubit.doIntent(
                  OrderDetailsReportIssueEvent(orderId, request: request),
                ),
                _OrderSupportMode.dispute => _cubit.doIntent(
                  OrderDetailsCreateDisputeEvent(orderId, request: request),
                ),
              };
              return success;
            },
          ),
        );
      },
    );
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
            _controller.applyAssignmentDetails(details);
            _dismissPickupOtpSheetIfNeeded();
          }

          final notificationMessage = state.notificationMessage;
          if ((notificationMessage ?? '').trim().isNotEmpty) {
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
              exception.errorType.showSnackBar) {
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
            isActionLoading: state.isActionLoading,
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

enum _OrderSupportMode { issue, dispute }

class _SupportReasonOption {
  const _SupportReasonOption({
    required this.code,
    required this.labelAr,
    required this.labelEn,
  });

  final String code;
  final String labelAr;
  final String labelEn;
}

class _OrderSupportComposer extends StatefulWidget {
  const _OrderSupportComposer({required this.isArabic, required this.onSubmit});

  final bool isArabic;
  final Future<bool> Function(
    _OrderSupportMode mode,
    String reasonCode,
    String message,
  )
  onSubmit;

  @override
  State<_OrderSupportComposer> createState() => _OrderSupportComposerState();
}

class _OrderSupportComposerState extends State<_OrderSupportComposer> {
  late final TextEditingController _messageController;
  _OrderSupportMode _mode = _OrderSupportMode.issue;
  String? _selectedReasonCode;
  bool _isSubmitting = false;

  static const List<_SupportReasonOption> _issueReasons = [
    _SupportReasonOption(
      code: 'customer_unreachable',
      labelAr: 'العميل لا يرد',
      labelEn: 'Customer unreachable',
    ),
    _SupportReasonOption(
      code: 'merchant_delay',
      labelAr: 'تأخير من المتجر',
      labelEn: 'Merchant delay',
    ),
    _SupportReasonOption(
      code: 'address_problem',
      labelAr: 'مشكلة في العنوان',
      labelEn: 'Address problem',
    ),
    _SupportReasonOption(
      code: 'order_damaged',
      labelAr: 'الطلب تالف',
      labelEn: 'Order damaged',
    ),
  ];

  static const List<_SupportReasonOption> _disputeReasons = [
    _SupportReasonOption(
      code: 'payout_dispute',
      labelAr: 'اعتراض على المستحقات',
      labelEn: 'Payout dispute',
    ),
    _SupportReasonOption(
      code: 'wrong_order_value',
      labelAr: 'قيمة الطلب غير صحيحة',
      labelEn: 'Wrong order value',
    ),
    _SupportReasonOption(
      code: 'customer_claim',
      labelAr: 'اعتراض من العميل',
      labelEn: 'Customer claim',
    ),
  ];

  String _text(String ar, String en) => widget.isArabic ? ar : en;
  List<_SupportReasonOption> get _reasonOptions =>
      _mode == _OrderSupportMode.issue ? _issueReasons : _disputeReasons;
  String _reasonLabel(_SupportReasonOption option) =>
      widget.isArabic ? option.labelAr : option.labelEn;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _selectedReasonCode = _reasonOptions.first.code;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final reasonCode = (_selectedReasonCode ?? '').trim();
    final message = _messageController.text.trim();
    if (reasonCode.isEmpty || message.isEmpty) {
      CustomSnackbar.showError(
        context: context,
        message: _text(
          'اختار السبب واكتب الرسالة',
          'Choose a reason and enter a message',
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final success = await widget.onSubmit(_mode, reasonCode, message);
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    if (success) {
      Navigator.of(context).pop(_mode.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _text('فتح مشكلة أو نزاع', 'Open issue or dispute'),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _text(
              'استخدم report-issue للمشكلة التشغيلية و dispute للاعتراض المرتبط بالطلب.',
              'Use report-issue for operational problems and dispute for order-related objections.',
            ),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          SegmentedButton<_OrderSupportMode>(
            segments: [
              ButtonSegment<_OrderSupportMode>(
                value: _OrderSupportMode.issue,
                label: Text(_text('مشكلة', 'Issue')),
                icon: const Icon(Icons.report_problem_outlined),
              ),
              ButtonSegment<_OrderSupportMode>(
                value: _OrderSupportMode.dispute,
                label: Text(_text('نزاع', 'Dispute')),
                icon: const Icon(Icons.gavel_rounded),
              ),
            ],
            selected: <_OrderSupportMode>{_mode},
            showSelectedIcon: false,
            onSelectionChanged: (selection) {
              setState(() {
                _mode = selection.first;
                _selectedReasonCode = _reasonOptions.first.code;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedReasonCode,
            borderRadius: BorderRadius.circular(18),
            decoration: InputDecoration(
              labelText: _text('السبب', 'Reason'),
              filled: true,
              fillColor: scheme.surfaceContainerLowest,
            ),
            items: _reasonOptions
                .map(
                  (option) => DropdownMenuItem<String>(
                    value: option.code,
                    child: Text(_reasonLabel(option)),
                  ),
                )
                .toList(growable: false),
            onChanged: _isSubmitting
                ? null
                : (value) {
                    setState(() {
                      _selectedReasonCode = value;
                    });
                  },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _messageController,
            maxLines: 4,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              labelText: _text('الرسالة', 'Details'),
              alignLabelWithHint: true,
              hintText: _text(
                'اكتب وصفًا سريعًا للمشكلة أو سبب الاعتراض',
                'Add a short description of the issue or dispute',
              ),
              filled: true,
              fillColor: scheme.surfaceContainerLowest,
            ),
          ),
          const SizedBox(height: 16),
          AppButton.filled(
            text: _mode == _OrderSupportMode.issue
                ? _text('إرسال المشكلة', 'Report issue')
                : _text('فتح النزاع', 'Create dispute'),
            isLoading: _isSubmitting,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
