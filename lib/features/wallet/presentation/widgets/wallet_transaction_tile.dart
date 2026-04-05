import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/wallet/presentation/mock/wallet_fake_data.dart';
import 'package:zadana_delivery/features/wallet/presentation/mock/wallet_localization_examples.dart';

class WalletTransactionTile extends StatelessWidget {
  const WalletTransactionTile({
    super.key,
    required this.item,
    required this.amountText,
  });

  final WalletTransactionItem item;
  final String amountText;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;
    final walletTheme = context.walletTheme;
    final kindColor = _kindColor(context, item.kind);
    final statusColor = _statusColor(context, item.status);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: walletTheme.softBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: kindColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(_kindIcon(item.kind), color: kindColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        locale.walletTransactionKindLabel(item.kind),
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size14,
                          color: color.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      amountText,
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size14,
                        color: item.amount >= 0
                            ? walletTheme.successTint
                            : color.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.note,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size11,
                    color: color.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MetaPill(
                      label: locale.walletTransactionStatusLabel(item.status),
                      color: statusColor,
                    ),
                    _MetaPill(label: item.reference, color: color.primary),
                    _MetaPill(
                      label: DateFormat('d MMM, h:mm a').format(item.date),
                      color: color.secondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _kindIcon(WalletTransactionKind kind) {
    switch (kind) {
      case WalletTransactionKind.delivery:
        return Icons.local_shipping_rounded;
      case WalletTransactionKind.withdrawal:
        return Icons.south_west_rounded;
      case WalletTransactionKind.bonus:
        return Icons.auto_awesome_rounded;
      case WalletTransactionKind.adjustment:
        return Icons.tune_rounded;
    }
  }

  Color _kindColor(BuildContext context, WalletTransactionKind kind) {
    final walletTheme = context.walletTheme;

    switch (kind) {
      case WalletTransactionKind.delivery:
        return walletTheme.successTint;
      case WalletTransactionKind.withdrawal:
        return walletTheme.infoTint;
      case WalletTransactionKind.bonus:
        return walletTheme.bonusTint;
      case WalletTransactionKind.adjustment:
        return walletTheme.warningTint;
    }
  }

  Color _statusColor(BuildContext context, WalletTransactionStatus status) {
    final walletTheme = context.walletTheme;

    switch (status) {
      case WalletTransactionStatus.completed:
        return walletTheme.successTint;
      case WalletTransactionStatus.pending:
        return walletTheme.warningTint;
      case WalletTransactionStatus.failed:
        return Theme.of(context).colorScheme.error;
    }
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size10,
          color: color,
        ),
      ),
    );
  }
}
