import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/widgets/auth/auth_text_field.dart';

class AuthPasswordField extends StatefulWidget {
  const AuthPasswordField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.validator,
    this.enabled = true,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final String? Function(String?) validator;
  final bool enabled;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return AuthTextField(
      controller: widget.controller,
      label: widget.label,
      hintText: widget.hintText,
      validator: widget.validator,
      textInputAction: TextInputAction.done,
      obscureText: _obscureText,
      enabled: widget.enabled,
      prefixIcon: Icon(
        Icons.lock_outline_rounded,
        color: color.onSurface.withValues(alpha: 0.6),
      ),
      suffixIcon: IconButton(
        onPressed: widget.enabled
            ? () => setState(() => _obscureText = !_obscureText)
            : null,
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_rounded
              : Icons.visibility_rounded,
        ),
      ),
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
