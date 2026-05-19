import 'package:flutter/foundation.dart';

import 'completed_order_collection_mixin.dart';
import 'completed_order_line_item_entity.dart';
import 'completed_order_types.dart';

@immutable
class CompletedOrder with CompletedOrderCollectionMixin {
  const CompletedOrder({
    required this.id,
    required this.merchantName,
    this.merchantImageUrl,
    required this.customerName,
    required this.completedAt,
    required this.status,
    required this.amount,
    required this.totalAmount,
    required this.codAmount,
    required this.distanceKm,
    required this.paymentMethod,
    required this.deliveryAddress,
    this.items = const [],
  });

  final String id;
  final String merchantName;
  final String? merchantImageUrl;
  final String customerName;
  final DateTime completedAt;
  final CompletedOrderStatus status;
  final double amount;
  @override
  final double totalAmount;
  @override
  final double codAmount;
  final double distanceKm;
  final CompletedOrderPaymentMethod paymentMethod;
  final String deliveryAddress;
  final List<CompletedOrderLineItem> items;
}
