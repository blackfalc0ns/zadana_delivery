import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_action_buttons.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_detail_card.dart';

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
    final vendorImage = order.vendorImageUrl.trim();
    final hasVendorImage = vendorImage.isNotEmpty;

    return DetailCard(
      title: locale.order_details_pickup_details_title,
      accent: AppColors.primary,
      child: Column(
        children: [
          Row(
            children: [
              if (hasVendorImage) ...[
                _VendorImageBox(imageUrl: vendorImage),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.vendorName,
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size14,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      locale.order_details_store_label,
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size11,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              CircleCallButton(onTap: onCall),
            ],
          ),
        ],
      ),
    );
  }
}

class _VendorImageBox extends StatelessWidget {
  const _VendorImageBox({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      
       
      ),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 44,
        height: 44,
        fit: BoxFit.cover,
        placeholder: (_, _) => Icon(
          Icons.storefront_rounded,
          color: AppColors.primary.withValues(alpha: 0.5),
          size: 22,
        ),
        errorWidget: (_, _, _) => Icon(
          Icons.storefront_rounded,
          color: AppColors.primary.withValues(alpha: 0.5),
          size: 22,
        ),
      ),
    );
  }
}
