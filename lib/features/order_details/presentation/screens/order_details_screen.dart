import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/errors/error_presentation.dart';
import 'package:zadana_delivery/core/errors/error_widgets/api_error_widget.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';
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
  });

  final DriverOrderPreview order;
  final LatLng driverLocation;
  final bool startAccepted;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late final OrderDetailsController _controller;
  late final OrderDetailsCubit _cubit;
  String _lastAppliedAssignmentId = '';

  String get _itemsNote =>
      widget.order.packageNote ??
      context.localization.order_details_package_note_fallback;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<OrderDetailsCubit>();
    _controller = OrderDetailsController(
      order: widget.order,
      driverLocation: widget.driverLocation,
      startAccepted: widget.startAccepted,
    );
    _cubit.doIntent(OrderDetailsLoadAssignmentEvent(widget.order.id));
  }

  @override
  void dispose() {
    _cubit.close();
    _controller.dispose();
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

  void _confirmPickup() async {
    final locale = context.localization;
    await _showDecision(
      title: locale.order_details_pickup_dialog_title,
      message: locale.order_details_pickup_dialog_message(
        widget.order.vendorName,
      ),
      confirmLabel: locale.order_details_pickup_dialog_confirm,
      confirmColor: context.colorScheme.secondary,
      nextStage: OrderDeliveryStage.pickedUp,
    );
  }

  void _showItems() => OrderDetailsSheets.showOrderItemsSheet(
    context: context,
    items: _controller.orderItems,
    packageNote: _itemsNote,
  );

  void _showPickupOtp() => OrderDetailsSheets.showPickupOtpSheet(
    context: context,
    otp: _controller.pickupOtp,
    onConfirm: _confirmPickup,
  );

  void _showCustomerOtp() async {
    if (!_controller.deliveryOtpRequired) {
      _controller.updateStage(OrderDeliveryStage.delivered);
      Navigator.of(context).pop('accept');
      return;
    }
    if (!await OrderDetailsSheets.showCustomerOtpSheet(context) || !mounted) {
      return;
    }
    _controller.updateStage(OrderDeliveryStage.delivered);
    Navigator.of(context).pop('accept');
  }

  void _handlePickupAction() {
    if (!_controller.pickupOtpRequired) {
      _confirmPickup();
      return;
    }
    _showPickupOtp();
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

  void _finish() => Navigator.of(
    context,
  ).pop(_controller.stage == OrderDeliveryStage.pending ? 'reject' : 'accept');

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<OrderDetailsCubit, OrderDetailsState>(
        listenWhen: (previous, current) =>
            previous.details != current.details ||
            previous.failure != current.failure,
        listener: (context, state) {
          final details = state.details;
          if (details != null &&
              _lastAppliedAssignmentId != details.assignmentId) {
            _lastAppliedAssignmentId = details.assignmentId;
            _controller.applyAssignmentDetails(details);
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
                  onRetry: () => _cubit.doIntent(
                    OrderDetailsLoadAssignmentEvent(widget.order.id),
                  ),
                  onGoBack: _cubit.clearError,
                ),
              ),
            );
          }

          return OrderDetailsScreenView(
            controller: _controller,
            onBack: context.pop,
            onAcceptOrder: _acceptOrder,
            onShowPickupOtp: _handlePickupAction,
            onShowCustomerOtp: _showCustomerOtp,
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
          );
        },
      ),
    );
  }
}
