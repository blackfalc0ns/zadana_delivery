import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class DriverProfileStepHeader extends StatelessWidget {
  const DriverProfileStepHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.step,
    required this.total,
  });

  final String title;
  final String subtitle;
  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
        decoration: BoxDecoration(
            color: color.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Text(
              '$step/$total',
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                color: color.primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size18,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  color: color.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
