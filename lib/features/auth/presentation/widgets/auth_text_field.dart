import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getSemiBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size11,
            color: enabled
                ? color.onSurface
                : color.onSurface.withValues(alpha: 0.55),
          ),
        ),
        const SizedBox(height: Spacing.sm),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          enabled: enabled,
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size13,
            color: color.onSurface,
          ),
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size13,
              color: color.onSurface.withValues(alpha: 0.5),
            ),
            prefixIcon: prefixIcon == null
                ? null
                : Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 10,
                      end: 6,
                    ),
                    child: prefixIcon,
                  ),
            suffixIcon: suffixIcon,
            prefixIconColor: color.onSurface.withValues(alpha: 0.6),
            suffixIconColor: color.onSurface.withValues(alpha: 0.6),
            filled: true,
            fillColor: color.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Spacing.base,
              vertical: Spacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Spacing.inputRadius),
              borderSide: BorderSide(
                color: color.outline.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Spacing.inputRadius),
              borderSide: BorderSide(
                color: color.outline.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Spacing.inputRadius),
              borderSide: BorderSide(color: color.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Spacing.inputRadius),
              borderSide: BorderSide(color: color.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Spacing.inputRadius),
              borderSide: BorderSide(color: color.error, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Spacing.inputRadius),
              borderSide: BorderSide(
                color: color.outline.withValues(alpha: 0.2),
              ),
            ),
            errorStyle: getRegularStyle(
              fontFamily: FontConstant.cairo,
              color: color.error,
            ),
          ),
        ),
      ],
    );
  }
}
