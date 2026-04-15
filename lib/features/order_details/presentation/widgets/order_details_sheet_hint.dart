import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class OrderDetailsSheetHint extends StatelessWidget {
  const OrderDetailsSheetHint({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        context.localization.order_details_sheet_hint,
        textAlign: TextAlign.center,
        style: getSemiBoldStyle(
          fontFamily: FontConstant.cairo,
          color: scheme.onSecondaryContainer,
        ),
      ),
    );
  }
}
