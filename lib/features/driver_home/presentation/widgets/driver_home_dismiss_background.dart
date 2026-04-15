import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';

class DriverHomeDismissBackground extends StatelessWidget {
  const DriverHomeDismissBackground({
    super.key,
    required this.alignment,
    required this.icon,
    required this.color,
  });

  final Alignment alignment;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
      ),
      alignment: alignment,
      child: Icon(icon, color: Colors.white),
    );
  }
}
