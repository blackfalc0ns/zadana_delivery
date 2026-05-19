import 'package:zadana_delivery/features/order_details/data/models/order_assignment_details_model_dto.dart';
import 'package:zadana_delivery/features/order_details/domain/entities/order_assignment_details_entity.dart';

extension OrderAssignmentDetailsModelMapper on OrderAssignmentDetailsModelDto {
  OrderAssignmentDetailsEntity toEntity() {
    return OrderAssignmentDetailsEntity(
      assignmentId: assignmentId,
      orderId: orderId,
      orderNumber: orderNumber,
      assignmentStatus: assignmentStatus,
      assignmentStatusLabel: assignmentStatusLabel,
      homeState: homeState,
      homeStateLabel: homeStateLabel,
      allowedActions: allowedActions,
      vendorName: vendorName,
      vendorImageUrl: vendorImageUrl,
      pickupAddress: pickupAddress,
      pickupLatitude: pickupLatitude,
      pickupLongitude: pickupLongitude,
      storePhone: storePhone,
      customerName: customerName,
      deliveryAddress: deliveryAddress,
      deliveryLatitude: deliveryLatitude,
      deliveryLongitude: deliveryLongitude,
      customerPhone: customerPhone,
      paymentMethod: paymentMethod,
      paymentMethodLabel: paymentMethodLabel,
      totalAmount: totalAmount,
      codAmount: codAmount,
      pickupOtpRequired: pickupOtpRequired,
      pickupOtpStatus: pickupOtpStatus,
      pickupOtpStatusLabel: pickupOtpStatusLabel,
      deliveryOtpRequired: deliveryOtpRequired,
      deliveryOtpStatus: deliveryOtpStatus,
      deliveryOtpStatusLabel: deliveryOtpStatusLabel,
      pickupOtpCode: pickupOtpCode,
      driverArrivalState: driverArrivalState,
      driverArrivalStateLabel: driverArrivalStateLabel,
      orderItems: orderItems
          .map((item) => item.toEntity())
          .toList(growable: false),
    );
  }
}

extension OrderAssignmentItemModelMapper on OrderAssignmentItemModelDto {
  OrderAssignmentItemEntity toEntity() {
    return OrderAssignmentItemEntity(
      name: name,
      quantity: quantity,
      unitPrice: unitPrice,
      lineTotal: lineTotal,
      imageUrl: imageUrl,
      displaySize: displaySize,
      unit: unit,
      storeName: storeName,
    );
  }
}
