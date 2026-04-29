import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/order_collection_helper.dart';

class IncomingOrderCardMeta extends StatelessWidget {
  const IncomingOrderCardMeta({
    super.key,
    required this.codAmount,
    required this.paymentMethod,
    required this.distance,
  });

  final double codAmount;
  final String paymentMethod;
  final String distance;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final localizations = context.localization;
    final requiresCollection = OrderCollectionHelper.requiresCollection(
      codAmount,
    );
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 76, maxWidth: 92),
      child: Column(
        textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            requiresCollection
                ? OrderCollectionHelper.collectionAmountText(
                    context,
                    codAmount: codAmount,
                  )
                : OrderCollectionHelper.collectionStatusText(
                    context,
                    codAmount: codAmount,
                    paymentMethod: paymentMethod,
                  ),
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size16,
              color: color.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            requiresCollection
                ? OrderCollectionHelper.collectionLabel(context)
                : '$distance ${localizations.driver_home_distance_unit}',
            style: getSemiBoldStyle(
              fontFamily: FontConstant.cairo,
              color: color.onSurface.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class IncomingOrderMiniRow extends StatelessWidget {
  const IncomingOrderMiniRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          '$label:',
          style: getSemiBoldStyle(fontFamily: FontConstant.cairo),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              color: scheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
