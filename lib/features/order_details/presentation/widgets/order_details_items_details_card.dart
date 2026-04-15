import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_detail_card.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_items_section.dart';

class ItemsDetailsCard extends StatelessWidget {
  const ItemsDetailsCard({super.key, required this.items, required this.onTap});

  final List<DriverOrderItemPreview> items;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: context.localization.order_details_items_details_title,
      accent: AppColors.success,
      child: OrderItemsSection(items: items, onTap: onTap),
    );
  }
}
