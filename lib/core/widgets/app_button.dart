import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/widgets/custom_progress_indicator.dart';

/// ─────────────────────────────────────────────────────────────
/// Reusable button with loading state, icon, and variants.
/// ─────────────────────────────────────────────────────────────
enum AppButtonVariant { filled, outlined, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
    this.height,
    this.borderRadius,
    this.color,
    this.textColor,
    this.fontWeight,
  });

  /// Named factories for convenience.
  const AppButton.filled({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
    this.height,
    this.borderRadius,
    this.color,
    this.textColor,
    this.fontWeight,
  }) : variant = AppButtonVariant.filled;

  const AppButton.outlined({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isExpanded = true,
    this.icon,
    this.height,
    this.borderRadius,
    this.color,
    this.textColor,
    this.fontWeight,
  }) : variant = AppButtonVariant.outlined;

  const AppButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isExpanded = false,
    this.icon,
    this.height,
    this.borderRadius,
    this.color,
    this.textColor,
    this.fontWeight,
  }) : variant = AppButtonVariant.text;
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isExpanded;
  final IconData? icon;
  final double? height;
  final double? borderRadius;
  final Color? color;
  final Color? textColor;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final effectiveColor = color ?? colors.primary;
    final h = height ?? Spacing.buttonHeight;
    final r = borderRadius ?? Spacing.buttonRadius;

    Widget child = isLoading
        ? SizedBox(
            height: 30,
            width: 30,
            child: CustomProgressIndicator.compact(
              size: 18,
              tintColor: variant == AppButtonVariant.filled
                  ? (textColor ?? colors.onPrimary)
                  : effectiveColor,
            ),
          )
        : _buildContent(context, effectiveColor);

    Widget button;
    switch (variant) {
      case AppButtonVariant.filled:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveColor,
            foregroundColor: textColor ?? colors.onPrimary,
            minimumSize: Size(isExpanded ? double.infinity : 0, h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(r),
            ),
            elevation: 0,
          ),
          child: child,
        );
        break;
      case AppButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? effectiveColor,
            minimumSize: Size(isExpanded ? double.infinity : 0, h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(r),
            ),
            side: BorderSide(color: effectiveColor),
          ),
          child: child,
        );
        break;
      case AppButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor ?? effectiveColor,
            minimumSize: Size(isExpanded ? double.infinity : 0, h),
          ),
          child: child,
        );
        break;
    }
    return button;
  }

  Widget _buildContent(BuildContext context, Color effectiveColor) {
    final colors = Theme.of(context).colorScheme;
    final style = getBoldStyle(
      fontSize: FontSize.size16,
      fontFamily: FontConstant.cairo,
      color: variant == AppButtonVariant.filled
          ? (textColor ?? colors.onPrimary)
          : (textColor ?? effectiveColor),
    ).copyWith(fontWeight: fontWeight);

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: Spacing.sm),
          Text(text, style: style),
        ],
      );
    }
    return Text(text, style: style);
  }
}
