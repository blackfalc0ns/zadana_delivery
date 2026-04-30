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
    this.isActionLoading = false,
  });

  final OrderDetailsController controller;
  final VoidCallback onBack;
  final VoidCallback onAcceptOrder;
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
  final bool isActionLoading;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) => OrderDetailsScaffold(
        onBack: onBack,
        actions: [
          IconButton(
            onPressed: isActionLoading ? null : () => onRefresh(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
        bottomActions: OrderDetailsBottomActions(
          stage: controller.stage,
          pickupOtpRequired: controller.pickupOtpRequired,
          deliveryOtpRequired: controller.deliveryOtpRequired,
          canMarkPickedUp: controller.canMarkPickedUp,
          canMarkArrivedAtVendor: controller.canMarkArrivedAtVendor,
          canMarkArrivedAtCustomer: controller.canMarkArrivedAtCustomer,
          hasArrivedAtVendor: controller.hasArrivedAtVendor,
          hasArrivedAtCustomer: controller.hasArrivedAtCustomer,
          hasPickupOtpCode: controller.hasPickupOtpCode,
          isWaitingForMerchantConfirmation:
              controller.isWaitingForMerchantConfirmation,
          onAcceptOrder: onAcceptOrder,
          onArrivedAtVendor: onArrivedAtVendor,
          onShowPickupOtp: onShowPickupOtp,
          onArrivedAtCustomer: onArrivedAtCustomer,
          onStartDelivery: onStartDelivery,
          onShowCustomerOtp: onShowCustomerOtp,
          onFinish: onFinish,
        ),
        child: Stack(
          children: [
            OrderDetailsBody(
              activeStatusIndex: controller.activeStatusIndex,
              order: controller.order,
              isCashPayment: controller.isCashPayment,
              pickupOtpCode: controller.pickupOtpCode,
              isWaitingForMerchantConfirmation:
                  controller.isWaitingForMerchantConfirmation,
              items: controller.orderItems,
              markers: controller.markers,
              showStoreRouteFirst: controller.showStoreRouteFirst,
              storeLocation: controller.storeLocation,
              customerLocation: controller.customerLocation,
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
      ),
    );
  }
}
