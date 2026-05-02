import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/formatters/price_formatter.dart';

class OrderCollectionHelper {
  const OrderCollectionHelper._();

  static bool requiresCollection(double? codAmount) => (codAmount ?? 0) > 0;

  static bool isPaidOnline({
    required double? codAmount,
    String? paymentMethod,
  }) {
    if (requiresCollection(codAmount)) return false;

    final normalizedMethod = _normalizePaymentMethod(paymentMethod);
    return normalizedMethod == 'card' ||
        normalizedMethod == 'online' ||
        normalizedMethod == 'creditcard' ||
        normalizedMethod == 'creditdebitcard' ||
        normalizedMethod == 'applepay' ||
        normalizedMethod == 'banktransfer';
  }

  static String collectionAmountText(
    BuildContext context, {
    required double? codAmount,
  }) {
    final amount = codAmount ?? 0;
    return '${PriceFormatter.formatPrice(amount)} ${context.localization.currency}';
  }

  static String collectionStatusText(
    BuildContext context, {
    required double? codAmount,
    String? paymentMethod,
  }) {
    if (requiresCollection(codAmount)) {
      return _localized(
        context,
        ar: 'الدفع عند الاستلام',
        en: 'Cash on delivery',
      );
    }

    if (isPaidOnline(codAmount: codAmount, paymentMethod: paymentMethod)) {
      return _localized(context, ar: 'مدفوع', en: 'Paid');
    }

    return _localized(context, ar: 'لا يوجد تحصيل', en: 'No collection');
  }

  static String collectionSummaryText(
    BuildContext context, {
    required double? codAmount,
    String? paymentMethod,
  }) {
    if (requiresCollection(codAmount)) {
      return '${_localized(context, ar: 'تحصيل من العميل', en: 'Collect from customer')}: ${collectionAmountText(context, codAmount: codAmount)}';
    }

    return collectionStatusText(
      context,
      codAmount: codAmount,
      paymentMethod: paymentMethod,
    );
  }

  static String collectionLabel(BuildContext context) {
    return _localized(
      context,
      ar: 'تحصيل من العميل',
      en: 'Collect from customer',
    );
  }

  static String _normalizePaymentMethod(String? paymentMethod) {
    return (paymentMethod ?? '')
        .trim()
        .toLowerCase()
        .replaceAll('_', '')
        .replaceAll(' ', '');
  }

  static String _localized(
    BuildContext context, {
    required String ar,
    required String en,
  }) {
    final languageCode = Localizations.localeOf(context).languageCode;
    return languageCode.toLowerCase() == 'ar' ? ar : en;
  }
}
