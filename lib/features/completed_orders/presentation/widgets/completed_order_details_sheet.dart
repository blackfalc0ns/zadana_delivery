import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/formatters/price_formatter.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/widgets/completed_order_card_helpers.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/widgets/completed_order_details_parts.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/widgets/completed_order_hero_info_tile.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/widgets/completed_order_product_card.dart';

Future<void> showCompletedOrderDetailsSheet(
  BuildContext context,
  CompletedOrderDetails order,
) async {
  final scheme = Theme.of(context).colorScheme;
  final locale = context.localization;
  final localeName = Localizations.localeOf(context).languageCode;
  final timeText = DateFormat('h:mm a', localeName).format(order.completedAt);
  final dateText = DateFormat(
    'EEEE d MMMM',
    localeName,
  ).format(order.completedAt);
  final accentColor = completedOrderAccentColor(context, order.status);

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.52,
      maxChildSize: 0.94,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          children: [
            Center(
              child: Container(
                width: 58,
                height: 6,
                decoration: BoxDecoration(
                  color: scheme.outlineVariant.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 14),
            _CompletedOrderHero(order: order, accentColor: accentColor),
            if ((order.merchantPhone ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              CompletedOrderSheetSection(
                title: locale.completed_orders_merchant_label,
                accentColor: accentColor,
                child: CompletedOrderSheetRow(
                  label: locale.phone,
                  value: order.merchantPhone!,
                ),
              ),
            ],
            const SizedBox(height: 12),
            CompletedOrderSheetSection(
              title: locale.completed_orders_customer_section_title,
              accentColor: accentColor,
              child: Column(
                children: [
                  CompletedOrderSheetRow(
                    label: locale.completed_orders_customer_name_label,
                    value: order.customerName,
                  ),
                  const SizedBox(height: 10),
                  CompletedOrderSheetRow(
                    label: locale.completed_orders_delivery_address_label,
                    value: order.deliveryAddress,
                  ),
                  if ((order.customerPhone ?? '').trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    CompletedOrderSheetRow(
                      label: locale.phone,
                      value: order.customerPhone!,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            CompletedOrderSheetSection(
              title: locale.completed_orders_order_details_section_title,
              accentColor: accentColor,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CompletedOrderHeroInfoTile(
                          icon: Icons.calendar_month_rounded,
                          label: locale.completed_orders_date_label,
                          value: dateText,
                          accentColor: accentColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CompletedOrderHeroInfoTile(
                          icon: Icons.schedule_rounded,
                          label: locale.completed_orders_time_label,
                          value: timeText,
                          accentColor: accentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CompletedOrderSheetRow(
                    label: locale.payment_method,
                    value: completedOrderPaymentMethodLabel(
                      context,
                      order.paymentMethod,
                    ),
                  ),
                  if ((order.pickupAddress ?? '').trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    CompletedOrderSheetRow(
                      label: locale.driver_home_pickup_label,
                      value: order.pickupAddress!,
                    ),
                  ],
                  const SizedBox(height: 10),
                  CompletedOrderSheetRow(
                    label: locale.completed_orders_distance_label,
                    value:
                        '${order.distanceKm.toStringAsFixed(1)} ${locale.driver_home_distance_unit}',
                  ),
                  const SizedBox(height: 10),
                  CompletedOrderSheetRow(
                    label: localeName == 'ar'
                        ? 'مصاريف الدليفري'
                        : 'Delivery fee',
                    value:
                        '${PriceFormatter.formatPrice(order.deliveryFee)} ${locale.currency}',
                  ),
                  const SizedBox(height: 10),
                  CompletedOrderSheetRow(
                    label: completedOrderCollectionLabel(
                      context,
                      codAmount: order.codAmount,
                    ),
                    value: completedOrderCollectionValue(
                      context,
                      codAmount: order.codAmount,
                      paymentMethod: order.paymentMethod,
                    ),
                    highlight: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            CompletedOrderSheetSection(
              title: locale.completed_orders_items_section_title,
              accentColor: accentColor,
              child: Column(
                children: order.items
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: CompletedOrderProductCard(item: item),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _CompletedOrderHero extends StatelessWidget {
  const _CompletedOrderHero({required this.order, required this.accentColor});

  final CompletedOrderDetails order;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final locale = context.localization;
    final merchantImage = (order.merchantImageUrl ?? '').trim();
    final hasMerchantImage = merchantImage.isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accentColor.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(16),
             
            ),
            child: hasMerchantImage
                ? CachedNetworkImage(
                    imageUrl: merchantImage,
                    width: 48,
                    height: 48,
                   
                    placeholder: (_, _) => Center(
                      child: Text(
                        completedOrderMerchantEmoji(order.merchantName),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    errorWidget: (_, _, _) => Center(
                      child: Text(
                        completedOrderMerchantEmoji(order.merchantName),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  )
                : Text(
                    completedOrderMerchantEmoji(order.merchantName),
                    style: const TextStyle(fontSize: 24),
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.merchantName,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size15,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${locale.completed_orders_order_number_prefix} #${order.orderNumber}',
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size11,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
