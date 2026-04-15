import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_confirmation_dialog.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_customer_otp_sheet_content.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_order_items_sheet_content.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_pickup_otp_sheet_content.dart';

class OrderDetailsSheets {
  const OrderDetailsSheets._();

  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmLabel,
    required Color confirmColor,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        content: ConfirmationDialogContent(
          title: title,
          message: message,
          confirmColor: confirmColor,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          ConfirmationDialogActions(
            dialogContext: dialogContext,
            confirmLabel: confirmLabel,
            confirmColor: confirmColor,
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  static Future<void> showOrderItemsSheet({
    required BuildContext context,
    required List<DriverOrderItemPreview> items,
    required String packageNote,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.45,
        maxChildSize: 0.92,
        expand: false,
        builder: (_, scrollController) => OrderItemsSheetContent(
          scrollController: scrollController,
          items: items,
          packageNote: packageNote,
        ),
      ),
    );
  }

  static Future<void> showPickupOtpSheet({
    required BuildContext context,
    required String otp,
    required VoidCallback onConfirm,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => PickupOtpSheetContent(
        otp: otp,
        onConfirm: () {
          Navigator.of(sheetContext).pop();
          onConfirm();
        },
      ),
    );
  }

  static Future<bool> showCustomerOtpSheet(BuildContext context) async {
    var enteredOtp = '';
    final isConfirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => CustomerOtpSheetContent(
        sheetContext: sheetContext,
        onChanged: (value) => enteredOtp = value,
        onConfirm: () {
          if (enteredOtp.trim().isEmpty) {
            ScaffoldMessenger.of(sheetContext).showSnackBar(
              SnackBar(
                content: Text(
                  sheetContext.localization.order_details_enter_otp_snackbar,
                ),
              ),
            );
            return;
          }
          Navigator.of(sheetContext).pop(true);
        },
      ),
    );
    return isConfirmed == true;
  }
}
