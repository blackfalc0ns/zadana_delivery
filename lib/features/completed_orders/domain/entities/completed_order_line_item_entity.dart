import 'package:flutter/foundation.dart';

@immutable
class CompletedOrderLineItem {
  const CompletedOrderLineItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    this.imageUrl,
  });

  final String name;
  final int quantity;
  final double unitPrice;
  final double lineTotal;
  final String? imageUrl;
}
