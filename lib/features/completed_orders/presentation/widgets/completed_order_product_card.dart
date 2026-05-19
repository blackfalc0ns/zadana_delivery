import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/constants/assets.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';

class CompletedOrderProductCard extends StatelessWidget {
  const CompletedOrderProductCard({super.key, required this.item});

  final CompletedOrderLineItem item;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.28),
        ),
      ),
      child: Row(
        children: [
          _ItemImageBox(imageUrl: item.imageUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size13,
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.secondaryContainer.withValues(
                          alpha: 0.78,
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${locale.quantity}: ${item.quantity}',
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size10,
                          color: scheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${item.lineTotal.toStringAsFixed(0)} ${locale.currency} • ${item.unitPrice.toStringAsFixed(0)} ${locale.currency}',
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size10,
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

class _ItemImageBox extends StatelessWidget {
  const _ItemImageBox({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final resolvedImageUrl = imageUrl?.trim() ?? '';

    return Container(
      width: 42,
      height: 42,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: resolvedImageUrl.isEmpty
          ? const Image(image: AssetImage(Assets.notFound), fit: BoxFit.cover)
          : CachedNetworkImage(
              imageUrl: resolvedImageUrl,

              placeholder: (_, _) => const _ItemImagePlaceholder(),
              errorWidget: (_, _, _) => const Image(
                image: AssetImage(Assets.notFound),
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}

class _ItemImagePlaceholder extends StatelessWidget {
  const _ItemImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 14,
        height: 14,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
