import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_otp_value_card.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_sheet_components.dart';

class PickupOtpSheetContent extends StatelessWidget {
  const PickupOtpSheetContent({
    super.key,
    required this.otp,
    required this.onConfirm,
  });

  final String otp;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final scheme = context.colorScheme;
    return SheetContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetHandle(),
          const SizedBox(height: 18),
          Text(
            locale.order_details_pickup_code_title,
            textAlign: TextAlign.center,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size18,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            locale.order_details_pickup_code_subtitle,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 18),
          OtpValueCard(otp: otp),
          const SizedBox(height: 18),
          SheetConfirmButton(
            label: locale.order_details_confirm_pickup,
            onPressed: onConfirm,
          ),
        ],
      ),
    );
  }
}
