import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';

class DriverOrderPreview {
  const DriverOrderPreview({
    required this.title,
    required this.vendorName,
    required this.pickupAddress,
    required this.customerName,
    required this.deliveryAddress,
    required this.distance,
    required this.eta,
    required this.payout,
    required this.vendorInitials,
    required this.customerInitials,
  });

  final String title;
  final String vendorName;
  final String pickupAddress;
  final String customerName;
  final String deliveryAddress;
  final String distance;
  final String eta;
  final String payout;
  final String vendorInitials;
  final String customerInitials;
}

class IncomingOrderCard extends StatelessWidget {
  const IncomingOrderCard({
    super.key,
    required this.order,
    required this.onAccept,
    required this.onReject,
  });

  final DriverOrderPreview order;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.sm),
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.outline.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  order.title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size15,
                    color: color.onSurface,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: color.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  order.payout,
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size10,
                    color: color.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          _PartySection(
            title: 'المتجر',
            name: order.vendorName,
            subtitle: order.pickupAddress,
            initials: order.vendorInitials,
            accent: color.primary,
            icon: Icons.storefront_rounded,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),
          _PartySection(
            title: 'العميل',
            name: order.customerName,
            subtitle: order.deliveryAddress,
            initials: order.customerInitials,
            accent: color.secondary,
            icon: Icons.location_on_outlined,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _OrderInfoChip(
                  icon: Icons.route_outlined,
                  label: order.distance,
                ),
                const SizedBox(width: 6),
                _OrderInfoChip(
                  icon: Icons.schedule_rounded,
                  label: order.eta,
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            children: [
              Expanded(
                child: AppButton.outlined(
                  text: 'رفض',
                  onPressed: onReject,
                  color: color.error,
                  textColor: color.error,
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: AppButton.filled(
                  text: 'قبول',
                  onPressed: onAccept,
                  color: color.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PartySection extends StatelessWidget {
  const _PartySection({
    required this.title,
    required this.name,
    required this.subtitle,
    required this.initials,
    required this.accent,
    required this.icon,
    this.trailing,
  });

  final String title;
  final String name;
  final String subtitle;
  final String initials;
  final Color accent;
  final IconData icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: accent.withValues(alpha: 0.10),
          child: Text(
            initials,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size11,
              color: accent,
            ),
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: accent),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      title,
                      style: getMediumStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size10,
                        color: color.onSurface.withValues(alpha: 0.60),
                      ),
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: Spacing.sm),
                    trailing!,
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size13,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size11,
                  color: color.onSurface.withValues(alpha: 0.68),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrderInfoChip extends StatelessWidget {
  const _OrderInfoChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final chipColor = color.primary.withValues(alpha: 0.08);
    final foreground = color.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: 4),
          Text(
            label,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size11,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}
