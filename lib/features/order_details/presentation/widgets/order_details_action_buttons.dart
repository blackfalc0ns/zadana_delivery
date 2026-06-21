import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';

class DecisionButton extends StatelessWidget {
  const DecisionButton({
    super.key,
    required this.label,
    required this.foreground,
    required this.background,
    required this.borderColor,
    required this.onTap,
    this.isLoading = false,
  });

  final String label;
  final Color foreground;
  final Color background;
  final Color borderColor;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final effectiveBg = isLoading
        ? background.withValues(alpha: 0.55)
        : background;
    final effectiveBorder = isLoading
        ? borderColor.withValues(alpha: 0.35)
        : borderColor;
    return Material(
      color: effectiveBg,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          height: 54,
          decoration: BoxDecoration(
            color: effectiveBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: effectiveBorder),
          ),
          child: Center(
            child: Text(
              label,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: isLoading
                    ? foreground.withValues(alpha: 0.5)
                    : foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CircleCallButton extends StatelessWidget {
  const CircleCallButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: const SizedBox(
          width: 42,
          height: 42,
          child: Icon(Icons.call_rounded, color: AppColors.primary, size: 20),
        ),
      ),
    );
  }
}
