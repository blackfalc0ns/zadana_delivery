import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_action_buttons.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_detail_card.dart';
import 'package:zadana_delivery/features/order_details/presentation/widgets/order_details_info_tile.dart';

class PartyDetailsSection extends StatelessWidget {
  const PartyDetailsSection({
    super.key,
    required this.title,
    required this.accent,
    required this.nameLabel,
    required this.nameValue,
    required this.nameIcon,
    required this.addressLabel,
    required this.addressValue,
    required this.addressIcon,
    required this.onCall,
  });

  final String title;
  final Color accent;
  final String nameLabel;
  final String nameValue;
  final IconData nameIcon;
  final String addressLabel;
  final String addressValue;
  final IconData addressIcon;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    return DetailCard(
      title: title,
      accent: accent,
      child: Column(
        children: [
          InfoTile(
            icon: nameIcon,
            label: nameLabel,
            value: nameValue,
            accent: AppColors.primary,
            action: CircleCallButton(onTap: onCall),
          ),
          const SizedBox(height: 8),
          InfoTile(
            icon: addressIcon,
            label: addressLabel,
            value: addressValue,
            accent: AppColors.secondary,
          ),
        ],
      ),
    );
  }
}
