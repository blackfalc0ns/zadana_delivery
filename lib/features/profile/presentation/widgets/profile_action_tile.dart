import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_action_icon.dart';
import 'package:zadana_delivery/features/profile/presentation/widgets/profile_action_text.dart';

class ProfileActionTile extends StatelessWidget {
  const ProfileActionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.trailing,
    this.isDestructive = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final arrowColor = isDestructive
        ? colorScheme.error.withValues(alpha: 0.75)
        : colorScheme.onSurfaceVariant;
    return Material(
      color: colorScheme.surface.withValues(alpha: 0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: 14,
          ),
          child: Row(
            children: [
              ProfileActionIcon(icon: icon, iconColor: iconColor),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: ProfileActionText(
                  title: title,
                  subtitle: subtitle,
                  isDestructive: isDestructive,
                ),
              ),
              const SizedBox(width: Spacing.md),
              trailing ??
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 20,
                    color: arrowColor,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
