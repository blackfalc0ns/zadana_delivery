import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_customer_details_card.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_hero_card.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_items_details_card.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_map_card.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_route_buttons.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_status_card.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_store_details_card.dart';

class OrderDetailsBody extends StatelessWidget {
  const OrderDetailsBody({
    super.key,
    required this.activeStatusIndex,
    required this.order,
    required this.paymentMethod,
    required this.isCashPayment,
    required this.items,
    required this.markers,
    required this.showStoreRouteFirst,
    required this.storeLocation,
    required this.customerLocation,
    required this.onCallStore,
    required this.onCallCustomer,
    required this.onShowItems,
    required this.onOpenCustomerRoute,
    required this.onOpenStoreRoute,
  });

  final int activeStatusIndex;
  final DriverOrderPreview order;
  final String paymentMethod;
  final bool isCashPayment;
  final List<DriverOrderItemPreview> items;
  final Set<Marker> markers;
  final bool showStoreRouteFirst;
  final LatLng storeLocation;
  final LatLng customerLocation;
  final VoidCallback onCallStore;
  final VoidCallback onCallCustomer;
  final VoidCallback onShowItems;
  final VoidCallback onOpenCustomerRoute;
  final VoidCallback onOpenStoreRoute;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
            child: DeliveryStatusCard(activeIndex: activeStatusIndex),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HeroCard(
                    order: order,
                    paymentMethod: paymentMethod,
                    isCashPayment: isCashPayment,
                  ),
                  const SizedBox(height: 10),
                 
                  ItemsDetailsCard(items: items, onTap: onShowItems),
                  const SizedBox(height: 10),
                  StoreDetailsCard(order: order, onCall: onCallStore),
                  const SizedBox(height: 10),
                  CustomerDetailsCard(order: order, onCall: onCallCustomer),
                  const SizedBox(height: 10),
                  MapCard(
                    markers: markers,
                    target: showStoreRouteFirst
                        ? storeLocation
                        : customerLocation,
                  ),
                  const SizedBox(height: 12),
                  RouteButtons(
                    showStoreRouteFirst: showStoreRouteFirst,
                    onOpenCustomerRoute: onOpenCustomerRoute,
                    onOpenStoreRoute: onOpenStoreRoute,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
