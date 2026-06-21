import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/order_details/presentation/controllers/order_details_controller.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_action_buttons.dart';

class OrderDetailsBottomActions extends StatelessWidget {
  const OrderDetailsBottomActions({
    super.key,
    required this.controller,
    required this.onAcceptOrder,
    required this.onRejectOrder,
    required this.onArrivedAtVendor,
    required this.onShowPickupOtp,
    required this.onArrivedAtCustomer,
    required this.onStartDelivery,
    required this.onShowCustomerOtp,
    required this.onFinish,
    this.isLoading = false,
  });

  final OrderDetailsController controller;
  final VoidCallback onAcceptOrder;
  final VoidCallback onRejectOrder;
  final VoidCallback onArrivedAtVendor;
  final VoidCallback onShowPickupOtp;
  final VoidCallback onArrivedAtCustomer;
  final VoidCallback onStartDelivery;
  final VoidCallback onShowCustomerOtp;
  final VoidCallback onFinish;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final scheme = context.colorScheme;
    final stage = controller.stage;
    final deliveryOtpRequired = controller.deliveryOtpRequired;
    final canMarkArrivedAtVendor = controller.canMarkArrivedAtVendor;
    final hasArrivedAtVendor = controller.hasArrivedAtVendor;
    final isWaitingForMerchantConfirmation =
        controller.isWaitingForMerchantConfirmation;
    final canMarkArrivedAtCustomer = controller.canMarkArrivedAtCustomer;
    final hasArrivedAtCustomer = controller.hasArrivedAtCustomer;

    switch (stage) {
      case OrderDeliveryStage.pending:
        return Row(
          children: [
            Expanded(
              child: DecisionButton(
                label: locale.order_details_accept_order,
                foreground: Colors.white,
                background: scheme.primary,
                borderColor: scheme.primary,
                isLoading: isLoading,
                onTap: onAcceptOrder,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DecisionButton(
                label: locale.order_details_reject_order,
                foreground: scheme.error,
                background: scheme.errorContainer.withValues(alpha: 0.25),
                borderColor: scheme.error.withValues(alpha: 0.22),
                isLoading: isLoading,
                onTap: onRejectOrder,
              ),
            ),
          ],
        );
      case OrderDeliveryStage.accepted:
        if (canMarkArrivedAtVendor && !hasArrivedAtVendor) {
          return _StageActionButton(
            label: locale.order_details_arrived_at_vendor,
            color: scheme.secondary,
            isLoading: isLoading,
            onTap: onArrivedAtVendor,
          );
        }
        return _WaitingForMerchantIndicator(
          text: locale.order_details_waiting_for_merchant_confirmation,
        );
      case OrderDeliveryStage.arrivedAtVendor:
        if (canMarkArrivedAtVendor && !hasArrivedAtVendor) {
          return _StageActionButton(
            label: locale.order_details_arrived_at_vendor,
            color: scheme.secondary,
            isLoading: isLoading,
            onTap: onArrivedAtVendor,
          );
        }
        if (isWaitingForMerchantConfirmation) {
          return _WaitingForMerchantIndicator(
            text: locale.order_details_waiting_for_merchant_confirmation,
          );
        }
        return _StageActionButton(
          label: locale.order_details_confirm_pickup,
          color: scheme.secondary,
          isLoading: isLoading,
          onTap: onShowPickupOtp,
        );
      case OrderDeliveryStage.pickedUp:
        return _StageActionButton(
          label: locale.order_details_start_delivery,
          color: scheme.secondary,
          isLoading: isLoading,
          onTap: onStartDelivery,
        );
      case OrderDeliveryStage.onTheWay:
        if (canMarkArrivedAtCustomer && !hasArrivedAtCustomer) {
          return _StageActionButton(
            label: locale.order_details_arrived_at_customer,
            color: scheme.primary,
            isLoading: isLoading,
            onTap: onArrivedAtCustomer,
          );
        }
        return _StageActionButton(
          label: deliveryOtpRequired
              ? locale.order_details_confirm_delivery_with_code
              : locale.order_details_confirm_delivery,
          color: scheme.primary,
          isLoading: isLoading,
          onTap: onShowCustomerOtp,
        );
      case OrderDeliveryStage.delivered:
        return _StageActionButton(
          label: locale.order_details_order_delivered,
          color: scheme.primary,
          isLoading: isLoading,
          onTap: onFinish,
        );
    }
  }
}

class _StageActionButton extends StatelessWidget {
  const _StageActionButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.isLoading = false,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return DecisionButton(
      label: label,
      foreground: Colors.white,
      background: color,
      borderColor: color,
      isLoading: isLoading,
      onTap: onTap,
    );
  }
}

class _WaitingForMerchantIndicator extends StatelessWidget {
  const _WaitingForMerchantIndicator({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2.2),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
