import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/widgets/completed_order_card_helpers.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/widgets/completed_order_details_parts.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/widgets/completed_order_hero_info_tile.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/widgets/completed_order_product_card.dart';

Future<void> showCompletedOrderDetailsSheet(
  BuildContext context,
  CompletedOrder order,
) async {
  final scheme = Theme.of(context).colorScheme;
  final locale = context.localization;
  final localeName = Localizations.localeOf(context).languageCode;
  final timeText = DateFormat('h:mm a', localeName).format(order.completedAt);
  final dateText = DateFormat('EEEE d MMMM', localeName).format(order.completedAt);
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
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: scheme.outlineVariant,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                children: [
                  _CompletedOrderHero(order: order, accentColor: accentColor),
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
                        const SizedBox(height: 10),
                        CompletedOrderSheetRow(
                          label: locale.completed_orders_distance_label,
                          value:
                              '${order.distanceKm.toStringAsFixed(1)} ${locale.driver_home_distance_unit}',
                        ),
                        const SizedBox(height: 10),
                        CompletedOrderSheetRow(
                          label: locale.completed_orders_order_total_label,
                          value:
                              '${order.amount.toStringAsFixed(0)} ${locale.currency}',
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
          ],
        ),
      ),
    ),
  );
}

class _CompletedOrderHero extends StatelessWidget {
  const _CompletedOrderHero({required this.order, required this.accentColor});

  final CompletedOrder order;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final locale = context.localization;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            accentColor.withValues(alpha: 0.14),
            accentColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: scheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
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
                  '${locale.completed_orders_order_number_prefix} #${order.id}',
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
