import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class IncomingOrderCardMeta extends StatelessWidget {
  const IncomingOrderCardMeta({
    super.key,
    required this.payout,
    required this.distance,
  });

  final String payout;
  final String distance;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final localizations = context.localization;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 76, maxWidth: 92),
      child: Column(
        textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: payout,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size16,
                    color: color.primary,
                  ),
                ),
                TextSpan(
                  text: ' ${localizations.currency}',
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    color: color.primary,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '$distance ${localizations.driver_home_distance_unit}',
            style: getBoldStyle(
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
