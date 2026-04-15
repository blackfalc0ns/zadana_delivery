import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_party_section.dart';

class StoreDetailsCard extends StatelessWidget {
  const StoreDetailsCard({
    super.key,
    required this.order,
    required this.onCall,
  });

  final DriverOrderPreview order;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return PartyDetailsSection(
      title: locale.order_details_pickup_details_title,
      accent: AppColors.primary,
      nameLabel: locale.order_details_store_label,
      nameValue: order.vendorName,
      nameIcon: Icons.storefront_rounded,
      addressLabel: locale.order_details_store_address_label,
      addressValue: order.pickupAddress,
      addressIcon: Icons.pin_drop_rounded,
      onCall: onCall,
    );
  }
}
