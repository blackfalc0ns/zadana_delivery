import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class ConfirmationDialogContent extends StatelessWidget {
  const ConfirmationDialogContent({
    super.key,
    required this.title,
    required this.message,
    required this.confirmColor,
  });

  final String title;
  final String message;
  final Color confirmColor;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: confirmColor.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.verified_rounded, color: confirmColor, size: 28),
        ),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: TextAlign.center,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size16,
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size13,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class ConfirmationDialogActions extends StatelessWidget {
  const ConfirmationDialogActions({
    super.key,
    required this.dialogContext,
    required this.confirmLabel,
    required this.confirmColor,
  });

  final BuildContext dialogContext;
  final String confirmLabel;
  final Color confirmColor;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final locale = context.localization;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(46),
              side: BorderSide(
                color: scheme.outlineVariant.withValues(alpha: 0.80),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              locale.cancel,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size13,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(46),
              backgroundColor: confirmColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              confirmLabel,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size13,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
