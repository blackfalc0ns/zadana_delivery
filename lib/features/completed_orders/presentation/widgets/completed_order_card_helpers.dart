import 'package:flutter/material.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
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
  if (name.contains('ماكدونالدز')) return '🍔';
  if (name.contains('بيتزا')) return '🍕';
  if (name.contains('ستاربكس')) return '☕';
  if (name.contains('كارفور')) return '🛒';
  if (name.contains('كنتاكي')) return '🍗';
  return '🏬';
}

String completedOrderItemEmoji(String name) {
  if (name.contains('بيتزا')) return '🍕';
  if (name.contains('برجر') || name.contains('ماك')) return '🍔';
  if (name.contains('بطاطس')) return '🍟';
  if (name.contains('كوكا') || name.contains('عصير')) return '🥤';
  if (name.contains('قهوة') || name.contains('لاتيه')) return '☕';
  if (name.contains('كوكيز')) return '🍪';
  if (name.contains('حليب')) return '🥛';
  if (name.contains('بيض')) return '🥚';
  if (name.contains('دجاج') || name.contains('تويستر')) return '🍗';
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
