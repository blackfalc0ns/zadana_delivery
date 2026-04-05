import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/wallet/presentation/mock/wallet_fake_data.dart';
import 'package:zadana_delivery/features/wallet/presentation/mock/wallet_localization_examples.dart';

class WalletPreviewStateSwitcher extends StatelessWidget {
  const WalletPreviewStateSwitcher({
    super.key,
    required this.state,
    required this.onChanged,
  });

  final WalletPreviewState state;
  final ValueChanged<WalletPreviewState> onChanged;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: WalletPreviewState.values.map((item) {
        final isSelected = item == state;

        return InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => onChanged(item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.primary.withValues(alpha: 0.12)
                  : color.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: isSelected
                    ? color.primary.withValues(alpha: 0.35)
                    : color.outlineVariant.withValues(alpha: 0.45),
              ),
            ),
            child: Text(
              locale.walletPreviewLabel(item),
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size12,
                color: isSelected ? color.primary : color.onSurfaceVariant,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
