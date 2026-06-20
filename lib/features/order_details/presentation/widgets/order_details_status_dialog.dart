import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_snack_bar.dart';

/// Shows a success toast after an order status change.
///
/// If [serverMessage] is provided (from API response), it is displayed.
/// Otherwise falls back to the localized default message.
void showOrderStatusChangeToast(
  BuildContext context, {
  String? serverMessage,
}) {
  final message = (serverMessage ?? '').trim();
  if (message.isNotEmpty) {
    CustomSnackbar.showSuccess(context: context, message: message);
    return;
  }
  CustomSnackbar.showSuccess(
    context: context,
    message: context.localization.order_details_status_updated_success,
  );
}

/// Shows a blocking dialog informing that the order status has been updated
/// externally (e.g. via real-time push).
Future<void> showOrderStatusBlockingDialog(
  BuildContext context, {
  required String message,
}) {
  final locale = context.localization;
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      title: Text(locale.order_details_status_updated_title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(locale.order_details_ok),
        ),
      ],
    ),
  );
}
