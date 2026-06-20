import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_action_tile.dart';

class ProfileNotificationTile extends StatelessWidget {
  const ProfileNotificationTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.onChanged,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ProfileActionTile(
      title: title,
      subtitle: subtitle,
      icon: icon,
      iconColor: iconColor,
      onTap: onTap,
      trailing: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!value),
        child: IgnorePointer(
          child: Switch.adaptive(
            value: value,
            activeThumbColor: context.colorScheme.primary,
            activeTrackColor:
                context.colorScheme.primary.withValues(alpha: 0.35),
            onChanged: (_) {},
          ),
        ),
      ),
    );
  }
}
