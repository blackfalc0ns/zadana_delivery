import 'package:zadana_delivery/features/driver_home/domain/entities/driver_home_entity.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';

class DriverHomeOrderPreviewMapper {
  const DriverHomeOrderPreviewMapper._();

  static DriverOrderPreview fromOffer(DriverHomeOfferEntity offer) {
    return DriverOrderPreview(
      id: offer.assignmentId,
      title: offer.orderNumber,
      vendorName: offer.vendorName,
      pickupAddress: offer.pickupAddress,
      pickupLatitude: offer.pickupLatitude,
      pickupLongitude: offer.pickupLongitude,
      customerName: offer.customerName,
      deliveryAddress: offer.deliveryAddress,
      deliveryLatitude: offer.deliveryLatitude,
      deliveryLongitude: offer.deliveryLongitude,
      distance: offer.estimatedDistanceKm.toStringAsFixed(1),
      eta: offer.estimatedEta,
      payout: offer.codAmount.toStringAsFixed(2),
      totalAmount: offer.totalAmount,
      codAmount: offer.codAmount,
      vendorInitials: _resolveInitials(offer.vendorName, offer.vendorInitials),
      customerInitials: _resolveInitials(
        offer.customerName,
        offer.customerInitials,
      ),
      packageNote: offer.packageNote,
      countdownSeconds: offer.countdownSeconds,
      paymentMethod: offer.paymentMethod,
      orderItems: offer.orderItems
          .map(
            (item) => DriverOrderItemPreview(
              name: item.name,
              quantity: item.quantity,
              note: item.note,
            ),
          )
          .toList(),
    );
  }

  static DriverOrderPreview fromAssignment(
    DriverHomeAssignmentEntity assignment,
  ) {
    return DriverOrderPreview(
      id: assignment.assignmentId,
      title: assignment.orderNumber,
      vendorName: assignment.vendorName,
      pickupAddress: assignment.pickupAddress,
      pickupLatitude: assignment.pickupLatitude,
      pickupLongitude: assignment.pickupLongitude,
      customerName: assignment.orderNumber,
      deliveryAddress: assignment.deliveryAddress,
      deliveryLatitude: assignment.deliveryLatitude,
      deliveryLongitude: assignment.deliveryLongitude,
      distance: '0.0',
      eta: assignment.status,
      payout: assignment.codAmount.toStringAsFixed(2),
      totalAmount: assignment.totalAmount,
      codAmount: assignment.codAmount,
      vendorInitials: _resolveInitials(assignment.vendorName, null),
      customerInitials: _resolveInitials(assignment.orderNumber, null),
      countdownSeconds: 3600,
      storePhone: assignment.merchantContact,
      paymentMethod: assignment.paymentMethod,
      pickupOtpRequired: assignment.pickupOtpRequired,
      deliveryOtpRequired: assignment.deliveryOtpRequired,
      pickupOtpCode: assignment.pickupOtpCode,
      orderId: assignment.orderId,
    );
  }

  static String _resolveInitials(String source, String? preferred) {
    final preferredTrimmed = (preferred ?? '').trim();
    if (preferredTrimmed.isNotEmpty) return preferredTrimmed;

    final parts = source
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .toList();
    if (parts.isEmpty) return '--';
    return parts.map((part) => part.substring(0, 1)).join().toUpperCase();
  }
}
