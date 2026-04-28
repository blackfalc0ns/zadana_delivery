import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/order_details/presentation/controllers/order_details_controller.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_action_buttons.dart';

class OrderDetailsBottomActions extends StatelessWidget {
  const OrderDetailsBottomActions({
    super.key,
    required this.stage,
    required this.pickupOtpRequired,
    required this.deliveryOtpRequired,
    required this.onAcceptOrder,
    required this.onShowPickupOtp,
    required this.onStartDelivery,
    required this.onShowCustomerOtp,
    required this.onFinish,
  });

  final OrderDeliveryStage stage;
  final bool pickupOtpRequired;
  final bool deliveryOtpRequired;
  final VoidCallback onAcceptOrder;
  final VoidCallback onShowPickupOtp;
  final VoidCallback onStartDelivery;
  final VoidCallback onShowCustomerOtp;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final scheme = context.colorScheme;

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
                onTap: onFinish,
              ),
            ),
          ],
        );
      case OrderDeliveryStage.accepted:
        return _StageActionButton(
          label: pickupOtpRequired
              ? locale.order_details_show_pickup_code
              : locale.order_details_confirm_pickup,
          color: scheme.secondary,
          onTap: onShowPickupOtp,
        );
      case OrderDeliveryStage.pickedUp:
        return _StageActionButton(
          label: locale.order_details_start_delivery,
          color: scheme.secondary,
          onTap: onStartDelivery,
        );
      case OrderDeliveryStage.onTheWay:
        return _StageActionButton(
          label: deliveryOtpRequired
              ? locale.order_details_confirm_delivery_with_code
              : locale.order_details_confirm_delivery,
          color: scheme.primary,
          onTap: onShowCustomerOtp,
        );
      case OrderDeliveryStage.delivered:
        return _StageActionButton(
          label: locale.order_details_order_delivered,
          color: scheme.primary,
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
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecisionButton(
      label: label,
      foreground: Colors.white,
      background: color,
      borderColor: color,
      onTap: onTap,
    );
  }
}
