import 'package:flutter/material.dart';

import '../helpers/regex.dart';
import '../l10n/translations/app_localizations.dart';

abstract class Validations {
  static String? validateName(BuildContext context, String? name) {
    final normalizedName = name?.trim() ?? '';
    if (normalizedName.isEmpty) {
      return AppLocalizations.of(context)!.name_is_required;
    } else if (!AppRegExp.isNameValid(normalizedName)) {
      return AppLocalizations.of(context)!.name_is_not_valid;
    }
    return null;
  }

  static String? validateEmail(BuildContext context, String? email) {
    final localized = AppLocalizations.of(context)!;
    final normalizedEmail = email?.trim() ?? '';

    if (normalizedEmail.isEmpty) {
      return localized.email_is_required;
    }

    if (normalizedEmail.contains(' ')) {
      return _localizedMessage(
        context,
        ar: 'البريد الإلكتروني ما يقبل مسافات',
        en: 'Email must not contain spaces',
      );
    }

    if (!normalizedEmail.contains('@')) {
      return _localizedMessage(
        context,
        ar: 'أضف @ للبريد الإلكتروني',
        en: 'Email must contain @',
      );
    }

    final emailParts = normalizedEmail.split('@');
    if (emailParts.length != 2) {
      return _localizedMessage(
        context,
        ar: 'استخدم @ مرة وحدة فقط',
        en: 'Email must contain only one @',
      );
    }

    final localPart = emailParts.first;
    final domainPart = emailParts.last;

    if (localPart.isEmpty) {
      return _localizedMessage(
        context,
        ar: 'اكتب اسم المستخدم قبل @',
        en: 'Email must contain text before @',
      );
    }

    if (domainPart.isEmpty) {
      return _localizedMessage(
        context,
        ar: 'اكتب اسم النطاق بعد @',
        en: 'Email must contain a domain after @',
      );
    }

    if (!domainPart.contains('.')) {
      return _localizedMessage(
        context,
        ar: 'أكمل اسم النطاق مثل .com',
        en: 'Email must contain a domain like .com',
      );
    }

    final domainSections = domainPart.split('.');
    if (domainSections.any((section) => section.isEmpty)) {
      return _localizedMessage(
        context,
        ar: 'اسم النطاق غير مكتمل',
        en: 'Email domain is incomplete',
      );
    }

    final topLevelDomain = domainSections.last;
    if (topLevelDomain.length < 2) {
      return _localizedMessage(
        context,
        ar: 'امتداد البريد الإلكتروني غير مكتمل',
        en: 'Email extension is incomplete',
      );
    }

    if (!AppRegExp.isEmailValid(normalizedEmail)) {
      return localized.email_is_not_valid;
    }

    return null;
  }

  static String? email(BuildContext context, String? email) {
    return validateEmail(context, email);
  }

  static String? validateDriverRegistrationEmail(
    BuildContext context,
    String? email,
  ) {
    return validateEmail(context, email);
  }

  static String? validateEmailOrPhone(BuildContext context, String? value) {
    final localized = AppLocalizations.of(context)!;
    final normalizedValue = value?.trim() ?? '';

    if (normalizedValue.isEmpty) {
      return localized.this_field_is_required;
    }

    if (_looksLikePhoneNumber(normalizedValue)) {
      return validatePhoneNumber(context, normalizedValue);
    }

    return validateEmail(context, normalizedValue);
  }

  static String? validatePassword(BuildContext context, String? password) {
    final normalizedPassword = password?.trim() ?? '';

    if (normalizedPassword.isEmpty) {
      return AppLocalizations.of(context)!.password_is_required;
    }

    if (normalizedPassword.length < 8) {
      return _localizedMessage(
        context,
        ar: 'كلمة المرور لازم تكون 8 أحرف على الأقل',
        en: 'Password must be at least 8 characters',
      );
    }

    if (!RegExp(r'[A-Z]').hasMatch(normalizedPassword)) {
      return _localizedMessage(
        context,
        ar: 'أضف حرف كبير',
        en: 'Password must contain an uppercase letter',
      );
    }

    if (!RegExp(r'[a-z]').hasMatch(normalizedPassword)) {
      return _localizedMessage(
        context,
        ar: 'أضف حرف صغير',
        en: 'Password must contain a lowercase letter',
      );
    }

    if (!RegExp(r'[0-9]').hasMatch(normalizedPassword)) {
      return _localizedMessage(
        context,
        ar: 'أضف رقم',
        en: 'Password must contain a number',
      );
    }

    if (!RegExp(r'[#?!@$%^&*-]').hasMatch(normalizedPassword)) {
      return _localizedMessage(
        context,
        ar: 'أضف رمز مثل @ أو #',
        en: 'Password must contain a special character',
      );
    }

    return null;
  }

  static String? validateConfirmPassword(
    BuildContext context,
    String? password,
    String? confirmPassword,
  ) {
    final normalizedPassword = password?.trim() ?? '';
    final normalizedConfirmPassword = confirmPassword?.trim() ?? '';

    if (normalizedConfirmPassword.isEmpty) {
      return AppLocalizations.of(context)!.confirm_password_is_required;
    } else if (!AppRegExp.isPasswordValid(normalizedConfirmPassword)) {
      return AppLocalizations.of(context)!.confirm_password_is_not_valid;
    } else if (normalizedPassword != normalizedConfirmPassword) {
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
    final localized = AppLocalizations.of(context)!;
    final normalizedPhoneNumber = phoneNumber?.trim() ?? '';

    if (normalizedPhoneNumber.isEmpty) {
      return localized.phone_number_is_required;
    }

    return null;
  }

  static String? validateFutureDate(BuildContext context, String? value) {
    final localized = AppLocalizations.of(context)!;
    final normalizedValue = value?.trim() ?? '';

    if (normalizedValue.isEmpty) {
      return localized.this_field_is_required;
    }

    final date = _parseDate(normalizedValue);
    if (date == null) {
      return localized.driver_profile_invalid_date_error;
    }

    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly.isBefore(todayOnly)) {
      return localized.driver_profile_expiry_date_past_error;
    }

    return null;
  }

  static String? validateRequired(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.this_field_is_required;
    }
    return null;
  }

  static String? validOtp(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.verification_code_required;
    }
    if (value.trim().length < 4) {
      return AppLocalizations.of(context)!.verification_code_invalid;
    }
    return null;
  }

  static String _localizedMessage(
    BuildContext context, {
    required String ar,
    required String en,
  }) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return languageCode == 'ar' ? ar : en;
  }

  static bool _looksLikePhoneNumber(String value) {
    return RegExp(r'^[+]?\d+$').hasMatch(value);
  }

  static DateTime? _parseDate(String value) {
    final isoDate = DateTime.tryParse(value);
    if (isoDate != null) return isoDate;

    final slashParts = value.split('/');
    if (slashParts.length == 3) {
      final first = int.tryParse(slashParts[0]);
      final second = int.tryParse(slashParts[1]);
      final year = int.tryParse(slashParts[2]);
      if (first == null || second == null || year == null) return null;

      final day = first > 12 ? first : second;
      final month = first > 12 ? second : first;
      return _validDate(year, month, day);
    }

    final dashParts = value.split('-');
    if (dashParts.length == 3 && dashParts.first.length != 4) {
      final first = int.tryParse(dashParts[0]);
      final second = int.tryParse(dashParts[1]);
      final year = int.tryParse(dashParts[2]);
      if (first == null || second == null || year == null) return null;

      final day = first > 12 ? first : second;
      final month = first > 12 ? second : first;
      return _validDate(year, month, day);
    }

    return null;
  }

  static DateTime? _validDate(int year, int month, int day) {
    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }
    return date;
  }
}
