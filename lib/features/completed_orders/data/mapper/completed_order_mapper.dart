import 'package:zadana_delivery/features/completed_orders/data/models/completed_order_model_dto.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';

extension CompletedOrderListItemModelMapper on CompletedOrderListItemModelDto {
  CompletedOrder toEntity() {
    return CompletedOrder(
      id: id,
      merchantName: merchantName,
      customerName: customerName,
      completedAt: DateTime.tryParse(completedAtUtc)?.toLocal() ?? DateTime(0),
      status: _mapStatus(status),
      amount: amount,
      distanceKm: distanceKm,
      paymentMethod: _mapPaymentMethod(paymentMethod),
      deliveryAddress: deliveryAddress,
      items: items.map((item) => item.toEntity()).toList(growable: false),
    );
  }
}

extension CompletedOrderDetailsModelMapper on CompletedOrderDetailsModelDto {
  CompletedOrderDetails toEntity() {
    return CompletedOrderDetails(
      id: id,
      assignmentId: assignmentId,
      orderNumber: orderNumber.isEmpty ? id : orderNumber,
      merchantName: merchantName,
      merchantPhone: merchantPhone,
      customerName: customerName,
      customerPhone: customerPhone,
      pickupAddress: pickupAddress,
      deliveryAddress: deliveryAddress,
      status: _mapStatus(status),
      paymentMethod: _mapPaymentMethod(paymentMethod),
      amount: amount,
      deliveryFee: deliveryFee,
      distanceKm: distanceKm,
      completedAt: DateTime.tryParse(completedAtUtc)?.toLocal() ?? DateTime(0),
      items: items.map((item) => item.toEntity()).toList(growable: false),
    );
  }
}

extension CompletedOrderItemModelMapper on CompletedOrderItemModelDto {
  CompletedOrderLineItem toEntity() {
    return CompletedOrderLineItem(
      name: name,
      quantity: quantity,
      unitPrice: unitPrice,
      lineTotal: lineTotal,
    );
  }
}

CompletedOrderStatus _mapStatus(String value) {
  switch (value.trim().toLowerCase()) {
    case 'cancelled':
      return CompletedOrderStatus.cancelled;
    case 'deliveryfailed':
      return CompletedOrderStatus.deliveryFailed;
    case 'delivered':
    default:
      return CompletedOrderStatus.delivered;
  }
}

CompletedOrderPaymentMethod _mapPaymentMethod(String value) {
  switch (value.trim().toLowerCase()) {
    case 'card':
      return CompletedOrderPaymentMethod.card;
    case 'applepay':
      return CompletedOrderPaymentMethod.applePay;
    case 'banktransfer':
      return CompletedOrderPaymentMethod.bankTransfer;
    case 'cashondelivery':
    default:
      return CompletedOrderPaymentMethod.cashOnDelivery;
  }
}
