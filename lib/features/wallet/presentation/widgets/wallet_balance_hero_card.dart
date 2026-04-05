import 'dart:ui';

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
    required this.ctaLabel,
    required this.onWithdraw,
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
  final String ctaLabel;
  final VoidCallback onWithdraw;
  final Gradient gradient;
  final Color glowColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -28,
            right: -18,
            child: _GlowBubble(size: 110, color: glowColor),
          ),
          Positioned(
            bottom: -34,
            left: -12,
            child: _GlowBubble(
              size: 94,
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size13,
                  color: Colors.white.withValues(alpha: 0.78),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                balanceValue,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size12,
                  color: Colors.white.withValues(alpha: 0.82),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _MiniStat(
                      label: availableLabel,
                      value: availableValue,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MiniStat(label: pendingLabel, value: pendingValue),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              AppButton.filled(
                text: ctaLabel,
                onPressed: onWithdraw,
                color: Colors.white,
                textColor: const Color(0xFF0B5C71),
                icon: Icons.arrow_outward_rounded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size10,
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlowBubble extends StatelessWidget {
  const _GlowBubble({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
