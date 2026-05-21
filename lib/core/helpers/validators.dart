import 'package:flutter/material.dart';

import 'package:zadana_delivery/core/helpers/document_expiry_date_helper.dart';

import '../helpers/regex.dart';
import '../l10n/translations/app_localizations.dart';

abstract class Validations {
  static String? validateName(BuildContext context, String? name) {
    if (name == null || name.trim().isEmpty) {
      return AppLocalizations.of(context)!.name_is_required;
    }
    return null;
  }

  static String? validateEmail(BuildContext context, String? email) {
    if (email == null || email.trim().isEmpty) {
      return AppLocalizations.of(context)!.email_is_required;
    } else if (!AppRegExp.isEmailValid(email.trim())) {
      return AppLocalizations.of(context)!.email_is_not_valid;
    }
    return null;
  }

  static String? validateDriverRegistrationEmail(
    BuildContext context,
    String? email,
  ) {
    final normalized = email?.trim() ?? '';
    final baseValidation = validateEmail(context, normalized);
    if (baseValidation != null) {
      return baseValidation;
    }
    if (!normalized.toLowerCase().endsWith('.com')) {
      return Localizations.localeOf(context).languageCode == 'ar'
          ? 'البريد الإلكتروني يجب أن ينتهي بـ .com'
          : 'Email must end with .com';
    }
    return null;
  }

  static String? validateEmailOrPhone(BuildContext context, String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return AppLocalizations.of(context)!.this_field_is_required;
    }

    if (input.contains('@')) {
      return validateEmail(context, input);
    }

    return validatePhoneNumber(context, input);
  }

  static String? validatePassword(BuildContext context, String? password) {
    if (password == null || password.isEmpty) {
      return AppLocalizations.of(context)!.password_is_required;
    } else if (!AppRegExp.isPasswordValid(password)) {
      return _passwordRequirementsMessage(context, password);
    }
    return null;
  }

  static String? validateConfirmPassword(
    BuildContext context,
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return AppLocalizations.of(context)!.confirm_password_is_required;
    } else if (!AppRegExp.isPasswordValid(confirmPassword)) {
      return _passwordRequirementsMessage(context, confirmPassword);
    } else if (password != confirmPassword) {
      return AppLocalizations.of(
        context,
      )!.password_and_confirm_password_must_be_same;
    }
    return null;
  }

  static String? validatePhoneNumber(
    BuildContext context,
    String? phoneNumber,
  ) {
    if (phoneNumber == null || phoneNumber.trim().isEmpty) {
      return AppLocalizations.of(context)!.phone_number_is_required;
    }
    return null;
  }

  static String? validateRequired(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.this_field_is_required;
    }
    return null;
  }

  static String? validateFutureDate(BuildContext context, String? value) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return AppLocalizations.of(context)!.this_field_is_required;
    }

    final parsed = DocumentExpiryDateHelper.tryParse(normalized);
    if (parsed == null) {
      return AppLocalizations.of(context)!.driver_profile_invalid_date_error;
    }

    if (DocumentExpiryDateHelper.isExpired(normalized)) {
      return AppLocalizations.of(
        context,
      )!.driver_profile_expiry_date_past_error;
    }

    return null;
  }

  static String? validOtp(BuildContext context, String? value) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return AppLocalizations.of(context)!.verification_code_required;
    }
    if (normalized.length != 4) {
      return AppLocalizations.of(context)!.verification_code_invalid;
    }
    return null;
  }

  static String _passwordRequirementsMessage(
    BuildContext context,
    String password,
  ) {
    final locale = AppLocalizations.of(context)!;
    final missing = <String>[];

    if (password.length < 8) {
      missing.add(locale.password_requirement_min_length);
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      missing.add(locale.password_requirement_uppercase);
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      missing.add(locale.password_requirement_lowercase);
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      missing.add(locale.password_requirement_number);
    }
    if (!RegExp(r'[#?!@$%^&*-]').hasMatch(password)) {
      missing.add(locale.password_requirement_special_character);
    }

    if (missing.isEmpty) {
      return locale.password_is_not_valid;
    }

    return '${locale.password_requirements_prefix} ${missing.join(locale.password_requirements_separator)}';
  }
}
