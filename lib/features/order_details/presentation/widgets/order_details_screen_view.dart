import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';
import 'package:zadana_delivery/features/order_details/presentation/controllers/order_details_controller.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_body.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_bottom_actions.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_scaffold.dart';

class OrderDetailsScreenView extends StatelessWidget {
  const OrderDetailsScreenView({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onAcceptOrder,
    required this.onRejectOrder,
    required this.onArrivedAtVendor,
    required this.onShowPickupOtp,
    required this.onArrivedAtCustomer,
    required this.onShowCustomerOtp,
    required this.onStartDelivery,
    required this.onShowItems,
    required this.onCallStore,
    required this.onCallCustomer,
    required this.onOpenStoreRoute,
    required this.onOpenCustomerRoute,
    required this.onFinish,
    required this.onRefresh,
    required this.onOpenSupportComposer,
    this.isActionLoading = false,
  });

  final OrderDetailsController controller;
  final VoidCallback onBack;
  final VoidCallback onAcceptOrder;
  final VoidCallback onRejectOrder;
  final VoidCallback onArrivedAtVendor;
  final VoidCallback onShowPickupOtp;
  final VoidCallback onArrivedAtCustomer;
  final VoidCallback onStartDelivery;
  final VoidCallback onShowCustomerOtp;
  final VoidCallback onShowItems;
  final VoidCallback onCallStore;
  final VoidCallback onCallCustomer;
  final VoidCallback onOpenStoreRoute;
  final VoidCallback onOpenCustomerRoute;
  final VoidCallback onFinish;
  final Future<void> Function() onRefresh;
  final VoidCallback onOpenSupportComposer;
  final bool isActionLoading;

  @override
  Widget build(BuildContext context) {
    return OrderDetailsScaffold(
      onBack: onBack,
      actions: [
        IconButton(
          onPressed: isActionLoading ? null : onOpenSupportComposer,
          icon: const Icon(Icons.support_agent_rounded),
        ),
        IconButton(
          onPressed: isActionLoading ? null : onRefresh,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      bottomActions: AnimatedBuilder(
        animation: controller,
        builder: (_, _) => OrderDetailsBottomActions(
          controller: controller,
          onAcceptOrder: onAcceptOrder,
          onRejectOrder: onRejectOrder,
          onArrivedAtVendor: onArrivedAtVendor,
          onShowPickupOtp: onShowPickupOtp,
          onArrivedAtCustomer: onArrivedAtCustomer,
          onStartDelivery: onStartDelivery,
          onShowCustomerOtp: onShowCustomerOtp,
          onFinish: onFinish,
        ),
      ),
      child: Stack(
        children: [
          OrderDetailsBody(
            controller: controller,
            onCallStore: onCallStore,
            onCallCustomer: onCallCustomer,
            onShowItems: onShowItems,
            onOpenCustomerRoute: onOpenCustomerRoute,
            onOpenStoreRoute: onOpenStoreRoute,
            onRefresh: onRefresh,
          ),
          if (isActionLoading) ...[
            const ModalBarrier(dismissible: false, color: Colors.black26),
            const Center(child: CustomProgressIndicator()),
          ],
        ],
      ),
    );
  }
}
