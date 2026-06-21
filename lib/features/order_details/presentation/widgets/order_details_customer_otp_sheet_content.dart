import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/loading/loading_overlay.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_customer_otp_field.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_resend_otp_action.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_sheet_components.dart';

class CustomerOtpSheetContent extends StatefulWidget {
  const CustomerOtpSheetContent({
    super.key,
    required this.sheetContext,
    required this.loadingContext,
    required this.onSubmit,
    this.onVerified,
    this.onResend,
  });

  final BuildContext sheetContext;
  final BuildContext loadingContext;
  final Future<bool> Function(String otpCode) onSubmit;
  final Future<void> Function()? onVerified;
  final Future<bool> Function()? onResend;

  @override
  State<CustomerOtpSheetContent> createState() =>
      _CustomerOtpSheetContentState();
}

class _CustomerOtpSheetContentState extends State<CustomerOtpSheetContent> {
  static const int _deliveryOtpLength = 4;
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isSubmitting = false;

  Future<void> _showKeyboard() async {
    if (!mounted || _isSubmitting) return;
    FocusScope.of(context).requestFocus(_focusNode);
    await SystemChannels.textInput.invokeMethod<void>('TextInput.show');
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      await _showKeyboard();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submitIfPossible() async {
    if (_isSubmitting) return;

    final otpCode = _controller.text.trim();
    if (otpCode.length != _deliveryOtpLength) {
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
    LoadingOverlay.show(widget.loadingContext);
    try {
      final success = await widget.onSubmit(otpCode);
      if (!mounted) return;

      if (success) {
        // Hide the loading overlay before navigating away, because
        // pushReplacementNamed will unmount the loadingContext making it
        // impossible to hide afterwards.
        LoadingOverlay.hide(widget.loadingContext);
        Navigator.of(context).pop(true);
        if (widget.onVerified != null) {
          await Future<void>.delayed(const Duration(milliseconds: 180));
          await widget.onVerified!.call();
        }
        return;
      }

      _controller.clear();
      setState(() => _isSubmitting = false);
      await _showKeyboard();
    } finally {
      LoadingOverlay.hide(widget.loadingContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final scheme = context.colorScheme;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(widget.sheetContext).bottom,
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
              CustomerOtpField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: !_isSubmitting,
                maxLength: _deliveryOtpLength,
                onChanged: (value) {
                  setState(() {});
                  if (value.trim().length == _deliveryOtpLength) {
                    _submitIfPossible();
                  }
                },
              ),
              if (widget.onResend != null) ...[
                const SizedBox(height: 14),
                OrderDetailsResendOtpAction(onResend: widget.onResend!),
              ],
              const SizedBox(height: 18),
              SheetConfirmButton(
                label: locale.order_details_confirm_delivery,
                onPressed: _submitIfPossible,
                isEnabled:
                    _controller.text.trim().length == _deliveryOtpLength &&
                    !_isSubmitting,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
