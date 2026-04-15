import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_home_dismiss_background.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/incoming_order_card_widget.dart';

class DriverHomeOrdersSheet extends StatelessWidget {
  const DriverHomeOrdersSheet({
    super.key,
    required this.orders,
    required this.scrollController,
    required this.onRemoveOrder,
    required this.onOpenOrder,
    required this.onAcceptOrder,
    required this.onFocusLocation,
  });

  final List<DriverOrderPreview> orders;
  final ScrollController scrollController;
  final ValueChanged<String> onRemoveOrder;
  final ValueChanged<DriverOrderPreview> onOpenOrder;
  final ValueChanged<DriverOrderPreview> onAcceptOrder;
  final ValueChanged<DriverOrderPreview> onFocusLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.4,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
              itemCount: orders.length,
              itemBuilder: (context, index) => _OrderSheetItem(
                order: orders[index],
                onRemoveOrder: onRemoveOrder,
                onOpenOrder: onOpenOrder,
                onAcceptOrder: onAcceptOrder,
                onFocusLocation: onFocusLocation,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSheetItem extends StatelessWidget {
  const _OrderSheetItem({
    required this.order,
    required this.onRemoveOrder,
    required this.onOpenOrder,
    required this.onAcceptOrder,
    required this.onFocusLocation,
  });

  final DriverOrderPreview order;
  final ValueChanged<String> onRemoveOrder;
  final ValueChanged<DriverOrderPreview> onOpenOrder;
  final ValueChanged<DriverOrderPreview> onAcceptOrder;
  final ValueChanged<DriverOrderPreview> onFocusLocation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
      child: Dismissible(
        key: ValueKey(order.id),
        onDismissed: (_) => onRemoveOrder(order.id),
        background: DriverHomeDismissBackground(
          alignment: Alignment.centerLeft,
          icon: Icons.close_rounded,
          color: context.colorScheme.error,
        ),
        secondaryBackground: DriverHomeDismissBackground(
          alignment: Alignment.centerRight,
          icon: Icons.close_rounded,
          color: context.colorScheme.error,
        ),
        child: IncomingOrderCard(
          order: order,
          onTap: () => onOpenOrder(order),
          onAccept: () => onAcceptOrder(order),
          onReject: () => onRemoveOrder(order.id),
          onExpired: () => onRemoveOrder(order.id),
          onLocationTap: () => onFocusLocation(order),
        ),
      ),
    );
  }
}
