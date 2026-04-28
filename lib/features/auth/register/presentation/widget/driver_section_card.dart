import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class DriverSectionCard extends StatelessWidget {
  const DriverSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size15,
              color: color.onSurface,
            ),
          ),
          if ((subtitle ?? '').trim().isNotEmpty) ...[
          const SizedBox(height: 4),
            Text(
              subtitle!,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                color: color.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: Spacing.sm),
          child,
        ],
      ),
    );
  }
}
