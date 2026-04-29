import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_customer_otp_field.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_sheet_components.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_sheet_hint.dart';

class CustomerOtpSheetContent extends StatefulWidget {
  const CustomerOtpSheetContent({
    super.key,
    required this.sheetContext,
    required this.onSubmit,
  });

  final BuildContext sheetContext;
  final Future<bool> Function(String otpCode) onSubmit;

  @override
  State<CustomerOtpSheetContent> createState() => _CustomerOtpSheetContentState();
}

class _CustomerOtpSheetContentState extends State<CustomerOtpSheetContent> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
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
    if (otpCode.length != 4) {
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
    final success = await widget.onSubmit(otpCode);
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
                onChanged: (value) {
                  final otpCode = value.trim();
                  if (otpCode.length == 4) {
                    _submitIfPossible();
                  }
                },
              ),
              const SizedBox(height: 10),
              const OrderDetailsSheetHint(),
              const SizedBox(height: 18),
              SheetConfirmButton(
                label: locale.order_details_confirm_delivery,
                onPressed: _submitIfPossible,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
