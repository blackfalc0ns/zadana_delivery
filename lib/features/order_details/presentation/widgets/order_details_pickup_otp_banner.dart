import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_otp_value_card.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_resend_otp_action.dart';

class OrderDetailsPickupOtpBanner extends StatelessWidget {
  const OrderDetailsPickupOtpBanner({
    super.key,
    required this.otpCode,
    required this.isWaitingForMerchantConfirmation,
    this.onResend,
  });

  final String otpCode;
  final bool isWaitingForMerchantConfirmation;
  final Future<bool> Function()? onResend;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final locale = context.localization;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: otpCode));
        if (!context.mounted) return;
        CustomSnackbar.showInfo(
          context: context,
          message: locale.order_details_pickup_code_copied,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.secondary.withValues(alpha: 0.18),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.password_rounded,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    locale.order_details_pickup_code_title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size16,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                Icon(
                  Icons.copy_rounded,
                  size: 18,
                  color: scheme.onSurfaceVariant,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              locale.order_details_pickup_code_subtitle,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            OtpValueCard(otp: otpCode),
            if (onResend != null) ...[
              const SizedBox(height: 10),
              OrderDetailsResendOtpAction(onResend: onResend!),
            ],
            if (isWaitingForMerchantConfirmation) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2.2),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      locale.order_details_waiting_for_merchant_confirmation,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.cairo,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
