import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class DriverHomeConnectionSwitch extends StatelessWidget {
  const DriverHomeConnectionSwitch({
    super.key,
    required this.isOnline,
    required this.onChanged,
  });

  final bool isOnline;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isOnline ? color.primary : color.onSurface;
    final indicatorColor = isOnline ? const Color(0xFF20B45B) : color.outline;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isDark
                ? color.surfaceContainerHigh
                : color.surface.withValues(alpha: 0.98),
            isDark
                ? color.surfaceContainer
                : color.surfaceContainerLowest.withValues(alpha: 0.93),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isDark
              ? color.outlineVariant.withValues(alpha: 0.38)
              : Colors.white.withValues(alpha: 0.72),
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: isDark ? 0.20 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 16,
          end: 8,
          top: 7,
          bottom: 7,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: indicatorColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: indicatorColor.withValues(alpha: 0.35),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOnline
                      ? locale.driver_home_connection_online_title
                      : locale.driver_home_connection_offline_title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    color: accent,
                  ),
                ),
                Text(
                  isOnline
                      ? locale.driver_home_connection_online_subtitle
                      : locale.driver_home_connection_offline_subtitle,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size10,
                    color: color.onSurface.withValues(alpha: 0.58),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Transform.scale(
              scale: 0.78,
              child: Switch(
                value: isOnline,
                onChanged: onChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeThumbColor: color.primary,
                activeTrackColor: color.primary.withValues(alpha: 0.32),
                inactiveThumbColor: color.surface,
                inactiveTrackColor: color.outline.withValues(alpha: 0.28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
