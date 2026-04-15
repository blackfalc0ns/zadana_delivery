import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';
import 'package:zadana_delivery/features/order_details/presentation/controllers/order_details_controller.dart';
import 'package:zadana_delivery/features/order_details/presentation/helpers/order_details_launcher.dart';
import 'package:zadana_delivery/features/order_details/presentation/helpers/order_details_sheets.dart';
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

  String get _itemsNote =>
      widget.order.packageNote ??
      context.localization.order_details_package_note_fallback;

  @override
  void initState() {
    super.initState();
    _controller = OrderDetailsController(
      order: widget.order,
      driverLocation: widget.driverLocation,
      startAccepted: widget.startAccepted,
    );
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
    if (!await OrderDetailsSheets.showCustomerOtpSheet(context) || !mounted) {
      return;
    }
    _controller.updateStage(OrderDeliveryStage.delivered);
    Navigator.of(context).pop('accept');
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
  Widget build(BuildContext context) => OrderDetailsScreenView(
    controller: _controller,
    onBack: context.pop,
    onAcceptOrder: _acceptOrder,
    onShowPickupOtp: _showPickupOtp,
    onShowCustomerOtp: _showCustomerOtp,
    onShowItems: _showItems,
    onCallStore: () => _call(_controller.storePhone),
    onCallCustomer: () => _call(_controller.customerPhone),
    onOpenStoreRoute: () =>
        _route(_controller.storeLocation, widget.order.pickupAddress),
    onOpenCustomerRoute: () =>
        _route(_controller.customerLocation, widget.order.deliveryAddress),
    onFinish: _finish,
  );
}
