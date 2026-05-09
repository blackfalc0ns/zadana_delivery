import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/constants/app_constants.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_customer_otp_field.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_otp_value_card.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_resend_otp_action.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_sheet_components.dart';

class PickupOtpSheetContent extends StatefulWidget {
  const PickupOtpSheetContent({
    super.key,
    required this.otp,
    required this.sheetContext,
    this.onConfirm,
    this.onSubmit,
    this.onResend,
    this.onCopyTap,
  });

  final String otp;
  final BuildContext sheetContext;
  final VoidCallback? onConfirm;
  final Future<bool> Function(String otpCode)? onSubmit;
  final Future<bool> Function()? onResend;
  final VoidCallback? onCopyTap;

  @override
  State<PickupOtpSheetContent> createState() => _PickupOtpSheetContentState();
}

class _PickupOtpSheetContentState extends State<PickupOtpSheetContent> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isSubmitting = false;

  bool get _isEntryMode => widget.otp.trim().isEmpty && widget.onSubmit != null;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isEntryMode && mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submitIfPossible() async {
    final onSubmit = widget.onSubmit;
    if (onSubmit == null || _isSubmitting) return;

    final otpCode = _controller.text.trim();
    if (otpCode.length != AppConstants.otpLength) {
      ScaffoldMessenger.of(widget.sheetContext).showSnackBar(
        SnackBar(
          content: Text(
            widget.sheetContext.localization.order_details_enter_otp_snackbar,
          ),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final success = await onSubmit(otpCode);
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
      return;
    }

    _controller.clear();
    _focusNode.requestFocus();
    setState(() => _isSubmitting = false);
  }

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
          if (_isEntryMode)
            CustomerOtpField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: !_isSubmitting,
              onChanged: (value) {
                if (value.trim().length == AppConstants.otpLength) {
                  _submitIfPossible();
                }
              },
            )
          else
            GestureDetector(
              onTap: widget.onCopyTap,
              child: OtpValueCard(otp: widget.otp),
            ),
          if (widget.onResend != null) ...[
            const SizedBox(height: 14),
            OrderDetailsResendOtpAction(onResend: widget.onResend!),
          ],
          if (widget.onConfirm != null) ...[
            const SizedBox(height: 18),
            SheetConfirmButton(
              label: locale.order_details_confirm_pickup,
              onPressed: widget.onConfirm!,
            ),
          ] else if (_isEntryMode) ...[
            const SizedBox(height: 18),
            SheetConfirmButton(
              label: locale.order_details_confirm_pickup,
              onPressed: _submitIfPossible,
            ),
          ],
        ],
      ),
    );
  }
}
