import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/helpers/order_collection_helper.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/driver_order_preview.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({
    super.key,
    required this.order,
    required this.isCashPayment,
  });

  final DriverOrderPreview order;
  final bool isCashPayment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A7B8F), Color(0xFF149AB0)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.24),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: HeroCardText(order: order)),
              HeroCardPayout(order: order),
            ],
          ),
          const SizedBox(height: 8),
          HeroCardPaymentRow(
            codAmount: order.codAmount,
            paymentMethod: order.paymentMethod,
            isCashPayment: isCashPayment,
          ),
        ],
      ),
    );
  }
}

class HeroCardText extends StatelessWidget {
  const HeroCardText({super.key, required this.order});

  final DriverOrderPreview order;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          order.title,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size18,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          order.vendorName,
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            color: Colors.white.withValues(alpha: 0.82),
          ),
        ),
      ],
    );
  }
}

class HeroCardPayout extends StatelessWidget {
  const HeroCardPayout({super.key, required this.order});

  final DriverOrderPreview order;

  @override
  Widget build(BuildContext context) {
    final requiresCollection = OrderCollectionHelper.requiresCollection(
      order.codAmount,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
      ),
      child: Text(
        requiresCollection
            ? OrderCollectionHelper.collectionAmountText(
                context,
                codAmount: order.codAmount,
              )
            : OrderCollectionHelper.collectionStatusText(
                context,
                codAmount: order.codAmount,
                paymentMethod: order.paymentMethod,
              ),
        textAlign: TextAlign.center,
        style: getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size13,
          color: Colors.white,
        ),
      ),
    );
  }
}

class HeroCardPaymentRow extends StatelessWidget {
  const HeroCardPaymentRow({
    super.key,
    required this.codAmount,
    required this.paymentMethod,
    required this.isCashPayment,
  });

  final double codAmount;
  final String paymentMethod;
  final bool isCashPayment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            isCashPayment ? Icons.payments_rounded : Icons.credit_card_rounded,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              OrderCollectionHelper.collectionSummaryText(
                context,
                codAmount: codAmount,
                paymentMethod: paymentMethod,
              ),
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size13,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
