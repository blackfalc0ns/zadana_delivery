import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/l10n/translations/app_localizations.dart';
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
    required this.onShowPickupOtp,
    required this.onShowCustomerOtp,
    required this.onShowItems,
    required this.onCallStore,
    required this.onCallCustomer,
    required this.onOpenStoreRoute,
    required this.onOpenCustomerRoute,
    required this.onFinish,
  });

  final OrderDetailsController controller;
  final VoidCallback onBack;
  final VoidCallback onAcceptOrder;
  final VoidCallback onShowPickupOtp;
  final VoidCallback onShowCustomerOtp;
  final VoidCallback onShowItems;
  final VoidCallback onCallStore;
  final VoidCallback onCallCustomer;
  final VoidCallback onOpenStoreRoute;
  final VoidCallback onOpenCustomerRoute;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) => OrderDetailsScaffold(
        onBack: onBack,
        bottomActions: OrderDetailsBottomActions(
          stage: controller.stage,
          pickupOtpRequired: controller.pickupOtpRequired,
          deliveryOtpRequired: controller.deliveryOtpRequired,
          onAcceptOrder: onAcceptOrder,
          onShowPickupOtp: onShowPickupOtp,
          onStartDelivery: () =>
              controller.updateStage(OrderDeliveryStage.onTheWay),
          onShowCustomerOtp: onShowCustomerOtp,
          onFinish: onFinish,
        ),
        child: OrderDetailsBody(
          activeStatusIndex: controller.activeStatusIndex,
          order: controller.order,
          paymentMethod: _resolvePaymentMethodLabel(locale),
          isCashPayment: controller.isCashPayment,
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
        ),
      ),
    );
  }

  String _resolvePaymentMethodLabel(AppLocalizations locale) {
    final method = controller.paymentMethodCode.trim().toLowerCase();
    if (method == 'cashondelivery' || method == 'cash_on_delivery') {
      return locale.cash_on_delivery;
    }
    if (method == 'creditcard' ||
        method == 'credit_card' ||
        method == 'creditdebitcard') {
      return locale.credit_debit_card;
    }
    if (method.isEmpty) {
      return controller.isCashPayment
          ? locale.cash_on_delivery
          : locale.credit_debit_card;
    }
    return locale.credit_debit_card;
  }
}
