import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/wallet/presentation/mock/wallet_fake_data.dart';
import 'package:zadana_delivery/features/wallet/presentation/mock/wallet_localization_examples.dart';

class WalletPaymentMethodTile extends StatelessWidget {
  const WalletPaymentMethodTile({super.key, required this.item});

  final WalletPaymentMethodItem item;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;
    final walletTheme = context.walletTheme;
    final chipColor = item.isVerified
        ? walletTheme.successTint
        : walletTheme.warningTint;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: walletTheme.softBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: color.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locale.walletPaymentMethodLabel(item.kind),
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size14,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.maskedLabel,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size11,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: chipColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              item.isPrimary
                  ? locale.wallet_primary_method
                  : item.isVerified
                  ? locale.wallet_status_completed
                  : locale.wallet_unverified_method,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size10,
                color: chipColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
