import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_item_emoji.dart';

class OrderItemTile extends StatelessWidget {
  const OrderItemTile({super.key, required this.item});

  final DriverOrderItemPreview item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _ItemEmojiBox(name: item.name),
          const SizedBox(width: 12),
          Expanded(child: _OrderItemDetails(item: item)),
        ],
      ),
    );
  }
}

class _ItemEmojiBox extends StatelessWidget {
  const _ItemEmojiBox({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(orderDetailsItemEmoji(name), style: const TextStyle(fontSize: 21)),
    );
  }
}

class _OrderItemDetails extends StatelessWidget {
  const _OrderItemDetails({required this.item});

  final DriverOrderItemPreview item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.name,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size13,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _ItemQuantityBadge(quantity: item.quantity),
          ],
        ),
        if ((item.note ?? '').trim().isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            item.note!,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size11,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

class _ItemQuantityBadge extends StatelessWidget {
  const _ItemQuantityBadge({required this.quantity});

  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '${context.localization.quantity}: $quantity',
        style: getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size10,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
