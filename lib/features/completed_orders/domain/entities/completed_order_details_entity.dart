import 'package:flutter/foundation.dart';

import 'completed_order_collection_mixin.dart';
import 'completed_order_line_item_entity.dart';
import 'completed_order_types.dart';

@immutable
class CompletedOrderDetails with CompletedOrderCollectionMixin {
  const CompletedOrderDetails({
    required this.id,
    required this.assignmentId,
    required this.orderNumber,
    required this.merchantName,
    this.merchantImageUrl,
    required this.merchantPhone,
    required this.customerName,
    required this.customerPhone,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.status,
    required this.paymentMethod,
    required this.amount,
    required this.totalAmount,
    required this.codAmount,
    required this.deliveryFee,
    required this.distanceKm,
    required this.completedAt,
    this.items = const [],
  });

  final String id;
  final String? assignmentId;
  final String orderNumber;
  final String merchantName;
  final String? merchantImageUrl;
  final String? merchantPhone;
  final String customerName;
  final String? customerPhone;
  final String? pickupAddress;
  final String deliveryAddress;
  final CompletedOrderStatus status;
  final CompletedOrderPaymentMethod paymentMethod;
  final double amount;
  @override
  final double totalAmount;
  @override
  final double codAmount;
  final double deliveryFee;
  final double distanceKm;
  final DateTime completedAt;
  final List<CompletedOrderLineItem> items;
}
