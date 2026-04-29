import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';

class CompletedOrdersEmptyState extends StatelessWidget {
  const CompletedOrdersEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
  });

  final String title;
  final String subtitle;
  final CompletedOrderStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: 0.08),
              blurRadius: 28,
              offset: const Offset(0, 16),
              spreadRadius: -12,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CompletedOrdersEmptyIcon(status: status),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size18,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletedOrdersEmptyIcon extends StatelessWidget {
  const _CompletedOrdersEmptyIcon({required this.status});

  final CompletedOrderStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final palette = _paletteFor(scheme, status);

    return SizedBox(
      width: 112,
      height: 112,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              color: palette.shellColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: palette.ringColor.withValues(alpha: 0.30),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: palette.shadow.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                  spreadRadius: -16,
                ),
              ],
            ),
          ),
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: palette.coreColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: palette.ringColor.withValues(alpha: 0.16),
              ),
            ),
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: palette.shadow.withValues(alpha: 0.10),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                  spreadRadius: -10,
                ),
              ],
            ),
            child: Icon(palette.mainIcon, size: 28, color: palette.iconColor),
          ),
          Positioned(
            right: 18,
            bottom: 18,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: palette.badgeColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                palette.badgeIcon,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _EmptyStatePalette _paletteFor(
    ColorScheme scheme,
    CompletedOrderStatus status,
  ) {
    switch (status) {
      case CompletedOrderStatus.delivered:
        return const _EmptyStatePalette(
          shellColor: Color(0xFFE7F5F7),
          coreColor: Color(0xFFD3EDF1),
          ringColor: AppColors.primary,
          shadow: AppColors.primary,
          mainIcon: Icons.inventory_2_outlined,
          badgeIcon: Icons.check_rounded,
          badgeColor: AppColors.primary,
          iconColor: AppColors.primary,
        );
      case CompletedOrderStatus.cancelled:
        return const _EmptyStatePalette(
          shellColor: Color(0xFFF6F1EA),
          coreColor: Color(0xFFF8E2C8),
          ringColor: AppColors.secondary,
          shadow: AppColors.secondary,
          mainIcon: Icons.remove_shopping_cart_outlined,
          badgeIcon: Icons.close_rounded,
          badgeColor: AppColors.secondary,
          iconColor: AppColors.secondary,
        );
      case CompletedOrderStatus.deliveryFailed:
        return const _EmptyStatePalette(
          shellColor: Color(0xFFEFF7F5),
          coreColor: Color(0xFFDDEFE9),
          ringColor: AppColors.primary,
          shadow: AppColors.primary,
          mainIcon: Icons.local_shipping_outlined,
          badgeIcon: Icons.priority_high_rounded,
          badgeColor: AppColors.secondary,
          iconColor: AppColors.primary,
        );
    }
  }
}

class _EmptyStatePalette {
  const _EmptyStatePalette({
    required this.shellColor,
    required this.coreColor,
    required this.ringColor,
    required this.shadow,
    required this.mainIcon,
    required this.badgeIcon,
    required this.badgeColor,
    required this.iconColor,
  });

  final Color shellColor;
  final Color coreColor;
  final Color ringColor;
  final Color shadow;
  final IconData mainIcon;
  final IconData badgeIcon;
  final Color badgeColor;
  final Color iconColor;
}
