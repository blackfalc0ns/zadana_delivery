import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/constants/assets.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/auth/data/driver_profile_service.dart';
import 'package:zadana_delivery/features/driver_home/presentation/widgets/incoming_order_card.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final _profileService = DriverProfileService();
  final bool _isOnline = true;

  final List<DriverOrderPreview> _orders = const [
    DriverOrderPreview(
      title: 'طلب #1234',
      vendorName: 'سلة جرين ماركت',
      pickupAddress: '12 طريق الملك فيصل، مدينة نصر',
      customerName: 'منى عادل',
      deliveryAddress: '32 شارع عباس العقاد، مدينة نصر',
      distance: '3.2 كم',
      eta: '18 دقيقة',
      payout: '85 ريال',
      vendorInitials: 'جس',
      customerInitials: 'مع',
    ),
    DriverOrderPreview(
      title: 'طلب #1235',
      vendorName: 'صيدلية كير بلس',
      pickupAddress: '7 شارع مكرم عبيد، مدينة نصر',
      customerName: 'أحمد سامي',
      deliveryAddress: '14 شارع حسن المأمون، مدينة نصر',
      distance: '4.7 كم',
      eta: '22 دقيقة',
      payout: '96 ريال',
      vendorInitials: 'كب',
      customerInitials: 'أس',
    ),
    DriverOrderPreview(
      title: 'طلب #1236',
      vendorName: 'ديلي مارت إكسبريس',
      pickupAddress: '5 شارع النزهة، مصر الجديدة',
      customerName: 'سارة نبيل',
      deliveryAddress: '88 شارع الثورة، مصر الجديدة',
      distance: '2.5 كم',
      eta: '14 دقيقة',
      payout: '72 ريال',
      vendorInitials: 'دم',
      customerInitials: 'سن',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final identity = _profileService.identity;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          Spacing.base,
          Spacing.base,
          Spacing.base,
          Spacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HomeTopBar(
              isOnline: _isOnline,
              driverName: identity.fullName.isNotEmpty
                  ? identity.fullName
                  : (Localizations.localeOf(context).languageCode == 'ar'
                        ? 'مندوب زدنا'
                        : 'Zadana driver'),
            ),
            const SizedBox(height: Spacing.base),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.bolt_rounded, color: color.primary),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Localizations.localeOf(context).languageCode == 'ar'
                              ? 'أنت متصل الآن'
                              : 'You are online now',
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size14,
                            color: color.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          Localizations.localeOf(context).languageCode == 'ar'
                              ? 'راجع تفاصيل الاستلام والتسليم بسرعة قبل اتخاذ القرار.'
                              : 'Review pickup and drop-off details quickly before accepting.',
                          style: getRegularStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size12,
                            color: color.onSurface.withValues(alpha: 0.68),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.base),
            _IncomingOrdersSectionHeader(ordersCount: _orders.length),
            const SizedBox(height: Spacing.base),
            ..._orders.map(
              (order) => IncomingOrderCard(
                order: order,
                onAccept: () => _showSnackBar('تم قبول ${order.title}'),
                onReject: () => _showSnackBar('تم رفض ${order.title}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar({required this.isOnline, required this.driverName});

  final bool isOnline;
  final String driverName;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                driverName,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size15,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isOnline ? 'Available for orders' : 'Currently offline',
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size12,
                  color: color.onSurface.withValues(alpha: 0.68),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: Spacing.base),
        CircleAvatar(
          radius: 22,
          backgroundColor: color.primary.withValues(alpha: 0.12),
          child: Image.asset(Assets.logoDark, width: 24, height: 24),
        ),
      ],
    );
  }
}

class _IncomingOrdersSectionHeader extends StatelessWidget {
  const _IncomingOrdersSectionHeader({required this.ordersCount});

  final int ordersCount;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الطلبات الحالية',
                style: getMediumStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size12,
                  color: color.onSurface.withValues(alpha: 0.55),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'الطلبات الواردة',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size20,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.sm,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: color.secondary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.secondary.withValues(alpha: 0.18)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '$ordersCount جديد',
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size12,
                  color: color.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
