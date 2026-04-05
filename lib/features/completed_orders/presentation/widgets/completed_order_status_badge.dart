import 'package:flutter/material.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';

class CompletedOrderStatusBadge extends StatelessWidget {
  const CompletedOrderStatusBadge({
    super.key,
    required this.status,
  });

  final CompletedOrderStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = _color(scheme);

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Icon(_icon(), size: 14, color: color),
    );
  }

  Color _color(ColorScheme scheme) {
    switch (status) {
      case CompletedOrderStatus.delivered:
        return scheme.primary;
      case CompletedOrderStatus.cancelled:
        return scheme.error;
      case CompletedOrderStatus.deliveryFailed:
        return scheme.secondary;
    }
  }

  IconData _icon() {
    switch (status) {
      case CompletedOrderStatus.delivered:
        return Icons.check_rounded;
      case CompletedOrderStatus.cancelled:
        return Icons.close_rounded;
      case CompletedOrderStatus.deliveryFailed:
        return Icons.priority_high_rounded;
    }
  }
}
