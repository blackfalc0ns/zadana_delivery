import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class CustomerOtpField extends StatelessWidget {
  const CustomerOtpField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.enabled = true,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: true,
      enabled: enabled,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      maxLength: 4,
      onChanged: onChanged,
      style: getBoldStyle(
        fontFamily: FontConstant.cairo,
        fontSize: FontSize.size20,
        color: scheme.onSurface,
      ),
      decoration: InputDecoration(
        counterText: '',
        hintText: context.localization.order_details_customer_otp_hint,
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
