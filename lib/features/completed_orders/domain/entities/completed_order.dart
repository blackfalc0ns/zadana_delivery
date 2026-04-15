import 'package:flutter/foundation.dart';

@immutable
class CompletedOrder {
  const CompletedOrder({
    required this.id,
    required this.merchantName,
    required this.customerName,
    required this.completedAt,
    required this.status,
    required this.amount,
    required this.distanceKm,
    required this.paymentMethod,
    required this.deliveryAddress,
    this.items = const [],
  });

  final String id;
  final String merchantName;
  final String customerName;
  final DateTime completedAt;
  final CompletedOrderStatus status;
  final double amount;
  final double distanceKm;
  final CompletedOrderPaymentMethod paymentMethod;
  final String deliveryAddress;
  final List<CompletedOrderItem> items;
}

@immutable
class CompletedOrderItem {
  const CompletedOrderItem({
    required this.name,
    required this.quantity,
    this.note,
  });

  final String name;
  final int quantity;
  final String? note;
}

enum CompletedOrderStatus { delivered, cancelled, deliveryFailed }

enum CompletedOrderPaymentMethod {
  cashOnDelivery,
  card,
  applePay,
  bankTransfer,
}
