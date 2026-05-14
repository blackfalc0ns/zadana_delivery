import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/widgets/app_button.dart';

class WalletBalanceHeroCard extends StatelessWidget {
  const WalletBalanceHeroCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.balanceValue,
    required this.availableLabel,
    required this.availableValue,
    required this.pendingLabel,
    required this.pendingValue,
    required this.codLabel,
    required this.codValue,
    required this.ctaLabel,
    required this.onWithdraw,
    this.statusLabel,
    this.onDisabledWithdrawTap,
    this.withdrawHelperText,
    required this.gradient,
    required this.glowColor,
  });

  final String title;
  final String subtitle;
  final String balanceValue;
  final String availableLabel;
  final String availableValue;
  final String pendingLabel;
  final String pendingValue;
  final String codLabel;
  final String codValue;
  final String ctaLabel;
  final VoidCallback? onWithdraw;
  final String? statusLabel;
  final VoidCallback? onDisabledWithdrawTap;
  final String? withdrawHelperText;
  final Gradient gradient;
  final Color glowColor;

  bool get _isActionEnabled => onWithdraw != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE2EBEF)),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.12),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: getMediumStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size11,
                          color: Colors.white.withValues(alpha: 0.86),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        balanceValue,
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: 26,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                if ((statusLabel ?? '').trim().isNotEmpty)
                  _StatusBadge(
                    label: statusLabel!,
                    isEnabled: _isActionEnabled,
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size11,
                    color: const Color(0xFF6A7B83),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        label: availableLabel,
                        value: availableValue,
                        valueColor: const Color(0xFF0E7C91),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MetricCard(
                        label: pendingLabel,
                        value: pendingValue,
                        valueColor: const Color(0xFF495B63),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _InlineMetricRow(
                  label: codLabel,
                  value: codValue,
                  emphasized: !_isActionEnabled,
                ),
                if ((withdrawHelperText ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _HelperBanner(
                    message: withdrawHelperText!,
                    isEnabled: _isActionEnabled,
                  ),
                ],
                const SizedBox(height: 14),
                _isActionEnabled
                    ? AppButton.filled(
                        text: ctaLabel,
                        onPressed: onWithdraw,
                        color: const Color(0xFF0E7C91),
                        textColor: Colors.white,
                        icon: Icons.arrow_outward_rounded,
                        height: 46,
                        borderRadius: 16,
                      )
                    : _DisabledActionButton(
                        text: ctaLabel,
                        onTap: onDisabledWithdrawTap,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size10,
              color: const Color(0xFF758690),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size13,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineMetricRow extends StatelessWidget {
  const _InlineMetricRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: emphasized ? const Color(0xFFFFF6EA) : const Color(0xFFF5F8F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size10,
                color: const Color(0xFF758690),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size13,
              color: emphasized
                  ? const Color(0xFFCD7B1C)
                  : const Color(0xFF33474F),
            ),
          ),
        ],
      ),
    );
  }
}

class _HelperBanner extends StatelessWidget {
  const _HelperBanner({required this.message, required this.isEnabled});

  final String message;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final icon = isEnabled
        ? Icons.info_outline_rounded
        : Icons.lock_outline_rounded;
    final tint = isEnabled ? const Color(0xFF0E7C91) : const Color(0xFFCD7B1C);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: tint, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size11,
                color: const Color(0xFF55666E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.isEnabled});

  final String label;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isEnabled
            ? Colors.white.withValues(alpha: 0.18)
            : const Color(0x29FFD08A),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size10,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _DisabledActionButton extends StatelessWidget {
  const _DisabledActionButton({required this.text, this.onTap});

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline_rounded,
              color: Color(0xFF6F838B),
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: const Color(0xFF61767E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
