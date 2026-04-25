import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/helpers/validators.dart';
import 'package:zadana_delivery/core/widgets/auth/auth_text_field.dart';

class ProfileFormField extends StatelessWidget {
  const ProfileFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      controller: controller,
      label: label,
      hintText: hint,
      keyboardType: keyboardType,
      prefixIcon: Icon(icon),
      validator: (value) => Validations.validateRequired(context, value),
    );
  }
}
