import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_transaction_entity.dart';
import 'package:zadana_delivery/features/wallet/presentation/wallet_ui_labels.dart';

class WalletTransactionTile extends StatelessWidget {
  const WalletTransactionTile({
    super.key,
    required this.item,
    required this.amountText,
  });

  final DriverWalletTransactionEntity item;
  final String amountText;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;
    final kindColor = _kindColor(item.type);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: kindColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_kindIcon(item.type), color: kindColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.walletTransactionTypeLabel(item.type),
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size13,
                        color: color.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      DateFormat('d MMM, h:mm a').format(item.createdAt),
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size10,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _AmountPill(text: amountText, isIncoming: item.isIncoming),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
                label: item.isIncoming
                    ? locale.wallet_direction_in
                    : locale.wallet_direction_out,
                color: item.isIncoming ? AppColors.success : AppColors.warning,
              ),
              _MetaPill(
                label: item.referenceId?.trim().isNotEmpty == true
                    ? item.referenceId!
                    : item.referenceType,
                color: kindColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _kindIcon(String type) {
    switch (type.trim().toLowerCase()) {
      case 'orderrevenue':
        return Icons.local_shipping_rounded;
      case 'payout':
        return Icons.south_west_rounded;
      case 'refund':
        return Icons.restart_alt_rounded;
      case 'settlement':
        return Icons.account_balance_wallet_rounded;
      case 'cashcollected':
        return Icons.payments_rounded;
      case 'hold':
        return Icons.lock_clock_rounded;
      case 'release':
        return Icons.undo_rounded;
      case 'credit':
        return Icons.add_card_rounded;
      case 'debit':
        return Icons.remove_circle_outline_rounded;
      case 'adjustment':
      default:
        return Icons.tune_rounded;
    }
  }

  Color _kindColor(String type) {
    switch (type.trim().toLowerCase()) {
      case 'orderrevenue':
        return AppColors.success;
      case 'payout':
        return AppColors.info;
      case 'refund':
      case 'release':
        return AppColors.secondary;
      case 'settlement':
      case 'credit':
        return AppColors.success;
      case 'cashcollected':
      case 'hold':
      case 'debit':
        return AppColors.warning;
      case 'adjustment':
      default:
        return AppColors.warning;
    }
  }
}

class _AmountPill extends StatelessWidget {
  const _AmountPill({required this.text, required this.isIncoming});

  final String text;
  final bool isIncoming;

  @override
  Widget build(BuildContext context) {
    final tint = isIncoming ? AppColors.success : context.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size10,
          color: tint,
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size9,
          color: color,
        ),
      ),
    );
  }
}
