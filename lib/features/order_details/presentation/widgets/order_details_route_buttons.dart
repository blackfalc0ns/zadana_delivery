import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class RouteButtons extends StatelessWidget {
  const RouteButtons({
    super.key,
    required this.showStoreRouteFirst,
    required this.onOpenCustomerRoute,
    required this.onOpenStoreRoute,
  });

  final bool showStoreRouteFirst;
  final VoidCallback onOpenCustomerRoute;
  final VoidCallback onOpenStoreRoute;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final locale = context.localization;
    final customerAccent = colorScheme.primary;
    final storeAccent = colorScheme.secondary;

    return Column(
      children: [
        _RouteActionButton(
          label: locale.order_details_open_customer_location,
          hint: locale.order_details_open_customer_location_hint,
          icon: Icons.navigation_rounded,
          background: showStoreRouteFirst
              ? colorScheme.surfaceContainerLow
              : customerAccent,
          foreground: showStoreRouteFirst ? customerAccent : Colors.white,
          borderColor: showStoreRouteFirst
              ? customerAccent.withValues(alpha: 0.18)
              : null,
          onTap: onOpenCustomerRoute,
        ),
        const SizedBox(height: 8),
        _RouteActionButton(
          label: locale.order_details_open_store_location,
          hint: locale.order_details_open_store_location_hint,
          icon: Icons.store_mall_directory_rounded,
          background: showStoreRouteFirst
              ? storeAccent
              : colorScheme.surfaceContainerLow,
          foreground: showStoreRouteFirst ? Colors.white : storeAccent,
          borderColor: showStoreRouteFirst
              ? null
              : storeAccent.withValues(alpha: 0.18),
          onTap: onOpenStoreRoute,
        ),
      ],
    );
  }
}

class _RouteActionButton extends StatelessWidget {
  const _RouteActionButton({
    required this.label,
    required this.hint,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onTap,
    this.borderColor,
  });

  final String label;
  final String hint;
  final IconData icon;
  final Color background;
  final Color foreground;
  final Color? borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final hasFilledForeground = foreground == Colors.white;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(22),
            border: borderColor != null ? Border.all(color: borderColor!) : null,
            boxShadow: hasFilledForeground
                ? [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.14),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: hasFilledForeground
                      ? Colors.white.withValues(alpha: 0.16)
                      : foreground.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: foreground),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size14,
                        color: foreground,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hint,
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size11,
                        color: foreground.withValues(alpha: 0.82),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_rounded, color: foreground),
            ],
          ),
        ),
      ),
    );
  }
}
