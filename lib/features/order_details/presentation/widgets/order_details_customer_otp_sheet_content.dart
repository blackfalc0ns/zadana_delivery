import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_customer_otp_field.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_sheet_components.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_sheet_hint.dart';

class CustomerOtpSheetContent extends StatelessWidget {
  const CustomerOtpSheetContent({
    super.key,
    required this.sheetContext,
    required this.onChanged,
    required this.onConfirm,
  });

  final BuildContext sheetContext;
  final ValueChanged<String> onChanged;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final scheme = context.colorScheme;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
      ),
      child: SheetContainer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SheetHandle(),
              const SizedBox(height: 18),
              Text(
                locale.order_details_customer_otp_title,
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size18,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                locale.order_details_customer_otp_subtitle,
                textAlign: TextAlign.center,
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 18),
              CustomerOtpField(onChanged: onChanged),
              const SizedBox(height: 10),
              const OrderDetailsSheetHint(),
              const SizedBox(height: 18),
              SheetConfirmButton(
                label: locale.order_details_confirm_delivery,
                onPressed: onConfirm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
