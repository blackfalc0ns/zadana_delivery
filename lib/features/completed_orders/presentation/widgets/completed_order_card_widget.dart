import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/widgets/completed_order_card_helpers.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/widgets/completed_order_card_summary_parts.dart';

class CompletedOrderCard extends StatelessWidget {
  const CompletedOrderCard({super.key, required this.order, this.onTap});

  final CompletedOrder order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final locale = context.localization;
    final localeName = Localizations.localeOf(context).languageCode;
    final timeText = DateFormat('h:mm a', localeName).format(order.completedAt);
    final accentColor = completedOrderAccentColor(context, order.status);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: .5,
              color: scheme.outlineVariant.withValues(alpha: 0.45),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 12,
                offset: const Offset(0, 6),
                spreadRadius: -10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MerchantImageBox(
                    imageUrl: order.merchantImageUrl,
                    merchantName: order.merchantName,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.merchantName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size15,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          timeText,
                          style: getMediumStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size11,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  CompletedOrderStatusPill(
                    label: completedOrderStatusText(context, order.status),
                    color: accentColor,
                    background: accentColor.withValues(alpha: 0.12),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(
                height: 1,
                thickness: 1,
                color: scheme.outlineVariant.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: CompletedOrderMetricColumn(
                      label: locale.completed_orders_customer_label,
                      value: order.customerName,
                      valueColor: scheme.onSurface,
                    ),
                  ),
                  Expanded(
                    child: CompletedOrderMetricColumn(
                      label: locale.completed_orders_distance_label,
                      value:
                          '${order.distanceKm.toStringAsFixed(1)} ${locale.driver_home_distance_unit}',
                      valueColor: scheme.onSurface,
                    ),
                  ),
                  Expanded(
                    child: CompletedOrderMetricColumn(
                      label: completedOrderCollectionLabel(
                        context,
                        codAmount: order.codAmount,
                      ),
                      value: completedOrderCollectionValue(
                        context,
                        codAmount: order.codAmount,
                        paymentMethod: order.paymentMethod,
                      ),
                      valueColor: const Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_outward_rounded,
                      size: 15,
                      color: scheme.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      locale.completed_orders_view_details_hint,
                      style: getMediumStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size10,
                        color: scheme.secondary,
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
}

class _MerchantImageBox extends StatelessWidget {
  const _MerchantImageBox({required this.imageUrl, required this.merchantName});

  final String? imageUrl;
  final String merchantName;

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = (imageUrl ?? '').trim();
    final hasImage = resolvedUrl.isNotEmpty;

    return Container(
      width: 48,
      height: 48,
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      decoration: BoxDecoration(
       
        borderRadius: BorderRadius.circular(15),
      ),
      child: hasImage
          ? CachedNetworkImage(
              imageUrl: resolvedUrl,
              width: 48,
              height: 48,
            
              placeholder: (_, _) => const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (_, _, _) => Center(
                child: Text(
                  completedOrderMerchantEmoji(merchantName),
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            )
          : Text(
              completedOrderMerchantEmoji(merchantName),
              style: const TextStyle(fontSize: 24),
            ),
    );
  }
}
