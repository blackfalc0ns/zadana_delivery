import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/helpers/order_collection_helper.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';

Color completedOrderAccentColor(
  BuildContext context,
  CompletedOrderStatus status,
) {
  final scheme = Theme.of(context).colorScheme;
  switch (status) {
    case CompletedOrderStatus.delivered:
      return scheme.primary;
    case CompletedOrderStatus.cancelled:
    case CompletedOrderStatus.deliveryFailed:
      return const Color(0xFFD32F2F);
  }
}

String completedOrderStatusText(
  BuildContext context,
  CompletedOrderStatus status,
) {
  final locale = context.localization;
  switch (status) {
    case CompletedOrderStatus.delivered:
      return locale.order_delivered;
    case CompletedOrderStatus.cancelled:
      return locale.order_cancelled;
    case CompletedOrderStatus.deliveryFailed:
      return locale.order_delivery_failed;
  }
}

String completedOrderMerchantEmoji(String name) {
  final normalizedName = name.trim().toLowerCase();
  if (_containsAny(normalizedName, const ['pizza', 'بيتزا'])) return '🍕';
  if (_containsAny(normalizedName, const ['burger', 'mac', 'برجر', 'ماك'])) {
    return '🍔';
  }
  if (_containsAny(normalizedName, const [
    'coffee',
    'star',
    'قهوة',
    'ستاربكس',
  ])) {
    return '☕';
  }
  if (_containsAny(normalizedName, const [
    'market',
    'carrefour',
    'سوبر',
    'كارفور',
  ])) {
    return '🛒';
  }
  if (_containsAny(normalizedName, const [
    'chicken',
    'kfc',
    'دجاج',
    'كنتاكي',
  ])) {
    return '🍗';
  }
  return '🏬';
}

String completedOrderItemEmoji(String name) {
  final normalizedName = name.trim().toLowerCase();
  if (_containsAny(normalizedName, const ['pizza', 'بيتزا'])) return '🍕';
  if (_containsAny(normalizedName, const ['burger', 'mac', 'برجر', 'ماك'])) {
    return '🍔';
  }
  if (_containsAny(normalizedName, const ['fries', 'بطاطس'])) return '🍟';
  if (_containsAny(normalizedName, const [
    'juice',
    'cola',
    'coke',
    'عصير',
    'كوكا',
  ])) {
    return '🥤';
  }
  if (_containsAny(normalizedName, const [
    'coffee',
    'latte',
    'قهوة',
    'لاتيه',
  ])) {
    return '☕';
  }
  if (_containsAny(normalizedName, const ['cookie', 'كوكي'])) return '🍪';
  if (_containsAny(normalizedName, const ['milk', 'حليب'])) return '🥛';
  if (_containsAny(normalizedName, const ['egg', 'بيض'])) return '🥚';
  if (_containsAny(normalizedName, const [
    'chicken',
    'twister',
    'دجاج',
    'تويستر',
  ])) {
    return '🍗';
  }
  return '🍽️';
}

String completedOrderPaymentMethodLabel(
  BuildContext context,
  CompletedOrderPaymentMethod method,
) {
  final locale = context.localization;
  switch (method) {
    case CompletedOrderPaymentMethod.cashOnDelivery:
      return locale.cash_on_delivery;
    case CompletedOrderPaymentMethod.card:
      return locale.credit_debit_card;
    case CompletedOrderPaymentMethod.applePay:
      return locale.apple_pay;
    case CompletedOrderPaymentMethod.bankTransfer:
      return locale.bank_transfer;
  }
}

String completedOrderCollectionValue(
  BuildContext context, {
  required double codAmount,
  required CompletedOrderPaymentMethod paymentMethod,
}) {
  if (OrderCollectionHelper.requiresCollection(codAmount)) {
    return OrderCollectionHelper.collectionAmountText(
      context,
      codAmount: codAmount,
    );
  }

  return OrderCollectionHelper.collectionStatusText(
    context,
    codAmount: codAmount,
    paymentMethod: _paymentMethodCode(paymentMethod),
  );
}

String completedOrderCollectionLabel(
  BuildContext context, {
  required double codAmount,
}) {
  if (OrderCollectionHelper.requiresCollection(codAmount)) {
    return OrderCollectionHelper.collectionLabel(context);
  }

  final languageCode = Localizations.localeOf(context).languageCode;
  return languageCode.toLowerCase() == 'ar' ? 'حالة التحصيل' : 'Collection status';
}

String _paymentMethodCode(CompletedOrderPaymentMethod method) {
  switch (method) {
    case CompletedOrderPaymentMethod.cashOnDelivery:
      return 'CashOnDelivery';
    case CompletedOrderPaymentMethod.card:
      return 'Card';
    case CompletedOrderPaymentMethod.applePay:
      return 'ApplePay';
    case CompletedOrderPaymentMethod.bankTransfer:
      return 'BankTransfer';
  }
}

bool _containsAny(String value, List<String> candidates) {
  for (final candidate in candidates) {
    if (value.contains(candidate)) return true;
  }
  return false;
}
