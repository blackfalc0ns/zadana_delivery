import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/profile/presentation/models/profile_action_item_data.dart';

class ProfilePageHeaderCard extends StatelessWidget {
  const ProfilePageHeaderCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colorToken,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final ProfileColorToken colorToken;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final accent = _resolveTokenColor(colorScheme, colorToken);

    return Container(
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size15,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size11,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Color _resolveTokenColor(
    ColorScheme colorScheme,
    ProfileColorToken token,
  ) {
    switch (token) {
      case ProfileColorToken.primary:
        return colorScheme.primary;
      case ProfileColorToken.secondary:
        return colorScheme.secondary;
      case ProfileColorToken.tertiary:
        return colorScheme.tertiary;
      case ProfileColorToken.error:
        return colorScheme.error;
    }
  }
}
