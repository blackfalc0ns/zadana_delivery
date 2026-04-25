import 'package:flutter/foundation.dart';

import 'completed_order_line_item_entity.dart';
import 'completed_order_types.dart';

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
  final List<CompletedOrderLineItem> items;
}
