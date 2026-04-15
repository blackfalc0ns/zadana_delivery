import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_item_tile.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_sheet_components.dart';

class OrderItemsSheetContent extends StatelessWidget {
  const OrderItemsSheetContent({
    super.key,
    required this.scrollController,
    required this.items,
    required this.packageNote,
  });

  final ScrollController scrollController;
  final List<DriverOrderItemPreview> items;
  final String packageNote;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final scheme = context.colorScheme;
    final totalItems = items.fold<int>(0, (sum, item) => sum + item.quantity);
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            const SheetHandle(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
              child: Column(
                children: [
                  Text(
                    locale.order_details_order_items_title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size18,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${items.length} ${locale.order_details_items_unit} - $totalItems ${locale.order_details_pieces_unit}',
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            SheetNote(note: packageNote),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, index) => OrderItemTile(item: items[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
