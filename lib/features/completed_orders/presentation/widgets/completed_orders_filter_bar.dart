import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';

class CompletedOrdersFilterBar extends StatelessWidget {
  const CompletedOrdersFilterBar({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  final CompletedOrderStatus selectedStatus;
  final ValueChanged<CompletedOrderStatus> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 8),
            spreadRadius: -10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatusTab(
              label: locale.order_delivered,
              selected: selectedStatus == CompletedOrderStatus.delivered,
              onTap: () => onStatusChanged(CompletedOrderStatus.delivered),
            ),
          ),
          Expanded(
            child: _StatusTab(
              label: locale.order_cancelled,
              selected: selectedStatus == CompletedOrderStatus.cancelled,
              onTap: () => onStatusChanged(CompletedOrderStatus.cancelled),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusTab extends StatelessWidget {
  const _StatusTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: selected ? scheme.secondary : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                color: selected ? AppColors.white : scheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
