import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/constants/assets.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';

class OrderItemTile extends StatelessWidget {
  const OrderItemTile({super.key, required this.item});

  final DriverOrderItemPreview item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.16),
          width: 0.55,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.018),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          _ItemImageBox(imageUrl: item.imageUrl),
          const SizedBox(width: 10),
          Expanded(child: _OrderItemDetails(item: item)),
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
      width: 54,
      height: 54,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: resolvedImageUrl.isEmpty
          ? const Image(image: AssetImage(Assets.notFound), fit: BoxFit.cover)
          : CachedNetworkImage(
              imageUrl: resolvedImageUrl,
              fit: BoxFit.cover,
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
    return ColoredBox(
      color: AppColors.success.withValues(alpha: 0.10),
      child: const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _OrderItemDetails extends StatelessWidget {
  const _OrderItemDetails({required this.item});

  final DriverOrderItemPreview item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.name,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _ItemQuantityBadge(quantity: item.quantity),
          ],
        ),
    
       ],
    );
  }
}

class _ItemQuantityBadge extends StatelessWidget {
  const _ItemQuantityBadge({required this.quantity});

  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '${context.localization.quantity}: $quantity',
        style: getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size9,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
