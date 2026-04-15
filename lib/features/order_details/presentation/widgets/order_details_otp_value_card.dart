import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';

class OtpValueCard extends StatelessWidget {
  const OtpValueCard({super.key, required this.otp});

  final String otp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(
        otp,
        textAlign: TextAlign.center,
        style: getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: 34,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
