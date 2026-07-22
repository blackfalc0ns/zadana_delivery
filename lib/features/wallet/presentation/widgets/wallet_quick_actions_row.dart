import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/wallet/presentation/widgets/wallet_layout_widgets.dart';

class WalletQuickAction {
  const WalletQuickAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

class WalletQuickActionsRow extends StatelessWidget {
  const WalletQuickActionsRow({super.key, required this.actions});

  final List<WalletQuickAction> actions;

  @override
  Widget build(BuildContext context) {
    return WalletSurface(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: actions
            .asMap()
            .entries
            .map(
              (entry) => Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    end: entry.key == actions.length - 1 ? 0 : 8,
                  ),
                  child: _WalletQuickActionCard(action: entry.value),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _WalletQuickActionCard extends StatelessWidget {
  const _WalletQuickActionCard({required this.action});

  final WalletQuickAction action;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return InkWell(
      onTap: action.onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        height: 82,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(action.icon, color: colors.primary, size: 18),
            ),
            const SizedBox(height: 8),
            Text(
              action.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
