import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';

class DriverHomeRejectOrderDialog extends StatelessWidget {
  const DriverHomeRejectOrderDialog({
    super.key,
    required this.order,
    required this.dialogContext,
  });

  final DriverOrderPreview order;
  final BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 360;
    final useVerticalActions = screenWidth < 340;

    final cancelButton = OutlinedButton(
      onPressed: () => Navigator.of(dialogContext).pop(false),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(46),
        side: BorderSide(color: color.outline.withValues(alpha: 0.32)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(
        locale.cancel,
        textAlign: TextAlign.center,
        style: getSemiBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size13,
          color: color.onSurface.withValues(alpha: 0.72),
        ),
      ),
    );

    final confirmButton = FilledButton(
      onPressed: () => Navigator.of(dialogContext).pop(true),
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(46),
        backgroundColor: color.error,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(
        locale.driver_home_reject_order_dialog_confirm,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size13,
          color: Colors.white,
        ),
      ),
    );

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: isCompact ? 12 : 20,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      contentPadding: EdgeInsets.fromLTRB(
        isCompact ? 16 : 20,
        20,
        isCompact ? 16 : 20,
        12,
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: color.error.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close_rounded, color: color.error, size: 28),
            ),
            const SizedBox(height: 14),
            Text(
              locale.driver_home_reject_order_dialog_title,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size16,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              locale.driver_home_reject_order_dialog_message(
                order.title,
                order.vendorName,
              ),
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size13,
                color: color.onSurface.withValues(alpha: 0.74),
              ),
            ),
            const SizedBox(height: 18),
            if (useVerticalActions) ...[
              SizedBox(width: double.infinity, child: confirmButton),
              const SizedBox(height: 8),
              SizedBox(width: double.infinity, child: cancelButton),
            ] else
              Row(
                children: [
                  Expanded(child: cancelButton),
                  const SizedBox(width: 10),
                  Expanded(child: confirmButton),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
