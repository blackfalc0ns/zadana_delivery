import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_party_section.dart';

class CustomerDetailsCard extends StatelessWidget {
  const CustomerDetailsCard({
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
      title: locale.order_details_customer_details_title,
      accent: AppColors.secondary,
      nameLabel: locale.order_details_customer_name_label,
      nameValue: order.customerName,
      nameIcon: Icons.person_rounded,
      addressLabel: locale.order_details_customer_address_label,
      addressValue: order.deliveryAddress,
      addressIcon: Icons.home_rounded,
      onCall: onCall,
    );
  }
}
