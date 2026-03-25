import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/validators.dart';

class EmailPhoneInputField extends StatefulWidget {
  const EmailPhoneInputField({
    super.key,
    required this.controller,
    this.validator,
    this.textInputAction = TextInputAction.done,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;

  @override
  State<EmailPhoneInputField> createState() => _EmailPhoneInputFieldState();
}

class _EmailPhoneInputFieldState extends State<EmailPhoneInputField> {
  bool _isPhone = false;
  String? _errorText;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onTextChanged() {
    final text = widget.controller.text;

    if (text.isEmpty) {
      if (_isPhone) {
        setState(() {
          _isPhone = false;
          _errorText = null;
        });
      }
      return;
    }

    final isNumeric = RegExp(r'^[0-9+]+$').hasMatch(text);

    if (isNumeric != _isPhone) {
      setState(() => _isPhone = isNumeric);

      if (isNumeric && !text.startsWith('+966')) {
        final newText = '+966$text';
        widget.controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }

      Future.microtask(() {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  BoxDecoration _getCountrySelectorDecoration(BuildContext context) {
    final color = context.colorScheme;
    Color borderColor;
    double borderWidth;

    if (_errorText != null) {
      borderColor = color.error;
      borderWidth = _isFocused ? 1.5 : 1.0;
    } else if (_isFocused) {
      borderColor = color.primary;
      borderWidth = 1.5;
    } else {
      borderColor = color.outline.withValues(alpha: 0.2);
      borderWidth = 1.0;
    }

    return BoxDecoration(
      color: color.surface,
      borderRadius: BorderRadius.circular(Spacing.inputRadius),
      border: Border.all(color: borderColor, width: borderWidth),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Directionality(
                  textDirection: _isPhone
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  child: TextFormField(
                    focusNode: _focusNode,
                    controller: widget.controller,
                    keyboardType: _isPhone
                        ? TextInputType.phone
                        : TextInputType.emailAddress,
                    textInputAction: widget.textInputAction,
                    style: getRegularStyle(
                      fontSize: FontSize.size9,
                      fontFamily: FontConstant.cairo,
                      color: color.onSurface,
                    ),
                    validator: (value) {
                      String? error;

                      if (_isPhone) {
                        error = Validations.validatePhoneNumber(context, value);
                      } else {
                        error = Validations.validateEmail(context, value);
                      }

                      if (error == null && widget.validator != null) {
                        error = widget.validator?.call(value);
                      }

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted && _errorText != error) {
                          setState(() => _errorText = error);
                        }
                      });

                      return _isPhone ? null : error;
                    },
                    decoration: InputDecoration(
                      hintText: _isPhone
                          ? '5xxxxxxxx'
                          : locale.hint_email_or_phone,
                      hintStyle: getRegularStyle(
                        fontSize: FontSize.size13,
                        fontFamily: FontConstant.cairo,
                        color: color.onSurface.withValues(alpha: 0.5),
                      ),
                      prefixIcon: _isPhone
                          ? null
                          : Icon(
                              Icons.email_outlined,
                              color: color.onSurface.withValues(alpha: 0.6),
                              size: Spacing.iconMd,
                            ),
                      filled: true,
                      fillColor: color.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: Spacing.base,
                        vertical: Spacing.md,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          Spacing.inputRadius,
                        ),
                        borderSide: BorderSide(
                          color: color.outline.withValues(alpha: 0.2),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          Spacing.inputRadius,
                        ),
                        borderSide: BorderSide(
                          color: color.outline.withValues(alpha: 0.2),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          Spacing.inputRadius,
                        ),
                        borderSide: BorderSide(
                          color: color.primary,
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          Spacing.inputRadius,
                        ),
                        borderSide: BorderSide(color: color.error),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          Spacing.inputRadius,
                        ),
                        borderSide: BorderSide(color: color.error, width: 1.5),
                      ),
                      errorStyle: _isPhone
                          ? const TextStyle(height: 0, fontSize: 0)
                          : getRegularStyle(
                              fontSize: FontSize.size12,
                              fontFamily: FontConstant.cairo,
                              color: color.error,
                            ),
                    ),
                  ),
                ),
              ),
              if (_isPhone) ...[
                const SizedBox(width: Spacing.sm),
                Container(
                  decoration: _getCountrySelectorDecoration(context),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.base,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_drop_down,
                            color: color.onSurface.withValues(alpha: 0.6),
                            size: Spacing.iconMd,
                          ),
                          const SizedBox(width: 4),
                          const Text('🇸🇦', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (_isPhone && _errorText != null) ...[
          const SizedBox(height: Spacing.xs),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: Spacing.base),
            child: Text(
              _errorText!,
              style: getRegularStyle(
                fontSize: FontSize.size12,
                fontFamily: FontConstant.cairo,
                color: color.error,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
