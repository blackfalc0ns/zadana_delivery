import 'package:flutter/material.dart';
import 'package:zadana_delivery/features/order_details/presentation/controllers/order_details_controller.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_customer_details_card.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_hero_card.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_items_details_card.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_map_card.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_pickup_otp_banner.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_route_buttons.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_status_card.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_store_details_card.dart';

class OrderDetailsBody extends StatelessWidget {
  const OrderDetailsBody({
    super.key,
    required this.controller,
    required this.onCallStore,
    required this.onCallCustomer,
    required this.onShowItems,
    required this.onOpenCustomerRoute,
    required this.onOpenStoreRoute,
    required this.onRefresh,
  });

  final OrderDetailsController controller;
  final VoidCallback onCallStore;
  final VoidCallback onCallCustomer;
  final VoidCallback onShowItems;
  final VoidCallback onOpenCustomerRoute;
  final VoidCallback onOpenStoreRoute;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) => Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
              child: DeliveryStatusCard(
                activeIndex: controller.activeStatusIndex,
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AnimatedBuilder(
                      animation: controller,
                      builder: (context, _) {
                        final pickupOtpCode = controller.pickupOtpCode?.trim();
                        final hasPickupOtpCode =
                            pickupOtpCode?.isNotEmpty == true;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            HeroCard(
                              order: controller.order,
                              isCashPayment: controller.isCashPayment,
                            ),
                            const SizedBox(height: 10),
                            if (hasPickupOtpCode) ...[
                              OrderDetailsPickupOtpBanner(
                                otpCode: pickupOtpCode!,
                                isWaitingForMerchantConfirmation:
                                    controller.isWaitingForMerchantConfirmation,
                              ),
                              const SizedBox(height: 10),
                            ],
                          ],
                        );
                      },
                    ),
                    AnimatedBuilder(
                      animation: controller,
                      builder: (context, _) => ItemsDetailsCard(
                        items: controller.orderItems,
                        onTap: onShowItems,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnimatedBuilder(
                      animation: controller,
                      builder: (context, _) => StoreDetailsCard(
                        order: controller.order,
                        onCall: onCallStore,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnimatedBuilder(
                      animation: controller,
                      builder: (context, _) => CustomerDetailsCard(
                        order: controller.order,
                        onCall: onCallCustomer,
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnimatedBuilder(
                      animation: controller,
                      builder: (context, _) => MapCard(
                        markers: controller.markers,
                        target: controller.showStoreRouteFirst
                            ? controller.storeLocation
                            : controller.customerLocation,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AnimatedBuilder(
                      animation: controller,
                      builder: (context, _) => RouteButtons(
                        showStoreRouteFirst: controller.showStoreRouteFirst,
                        onOpenCustomerRoute: onOpenCustomerRoute,
                        onOpenStoreRoute: onOpenStoreRoute,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
