import 'package:flutter/material.dart';

class ProfileActionIcon extends StatelessWidget {
  const ProfileActionIcon({
    super.key,
    required this.icon,
    required this.iconColor,
  });

  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: iconColor.withValues(alpha: 0.08)),
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }
}
