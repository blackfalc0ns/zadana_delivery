import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';

class CompletedOrderCard extends StatelessWidget {
  const CompletedOrderCard({super.key, required this.order});

  final CompletedOrder order;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final localeName = Localizations.localeOf(context).languageCode;
    final timeText = DateFormat('h:mm a', localeName).format(order.completedAt);
    final accentColor = _accentColor(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showOrderDetailsSheet(context),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: .5,
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
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F2EA),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      _merchantEmoji(),
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
                  _StatusPill(
                    label: _statusText(),
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
                    child: _MetricColumn(
                      label: 'العميل',
                      value: order.customerName,
                      valueColor: scheme.onSurface,
                    ),
                  ),
                  Expanded(
                    child: _MetricColumn(
                      label: 'المسافة',
                      value: '${order.distanceKm.toStringAsFixed(1)} كم',
                      valueColor: scheme.onSurface,
                    ),
                  ),
                  Expanded(
                    child: _MetricColumn(
                      label: 'إجمالي الطلب',
                      value: '${order.amount.toStringAsFixed(0)} ج.م',
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
                      'اضغط لعرض التفاصيل',
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

  void _showOrderDetailsSheet(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final localeName = Localizations.localeOf(context).languageCode;
    final timeText = DateFormat('h:mm a', localeName).format(order.completedAt);
    final dateText = DateFormat('EEEE d MMMM', localeName).format(order.completedAt);
    final accentColor = _accentColor(context);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.52,
          maxChildSize: 0.94,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
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
                        Container(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.72),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  _merchantEmoji(),
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
                                      'طلب #${order.id}',
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
                        ),
                        const SizedBox(height: 12),
                        _SheetSection(
                          title: 'بيانات العميل',
                          accentColor: accentColor,
                          child: Column(
                            children: [
                              _SheetRow(label: 'اسم العميل', value: order.customerName),
                              const SizedBox(height: 10),
                              _SheetRow(
                                label: 'عنوان التوصيل',
                                value: order.deliveryAddress,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _SheetSection(
                          title: 'تفاصيل الطلب',
                          accentColor: accentColor,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _HeroInfoTile(
                                      icon: Icons.calendar_month_rounded,
                                      label: 'التاريخ',
                                      value: dateText,
                                      accentColor: accentColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _HeroInfoTile(
                                      icon: Icons.schedule_rounded,
                                      label: 'الوقت',
                                      value: timeText,
                                      accentColor: accentColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _SheetRow(
                                label: 'طريقة الدفع',
                                value: _paymentMethodLabel(),
                              ),
                              const SizedBox(height: 10),
                              _SheetRow(
                                label: 'المسافة',
                                value: '${order.distanceKm.toStringAsFixed(1)} كم',
                              ),
                              const SizedBox(height: 10),
                              _SheetRow(
                                label: 'إجمالي الطلب',
                                value: '${order.amount.toStringAsFixed(0)} ج.م',
                                highlight: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _SheetSection(
                          title: 'الأصناف والكميات',
                          accentColor: accentColor,
                          child: Column(
                            children: order.items
                                .map(
                                  (item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: _ProductCard(
                                      item: item,
                                      accentColor: accentColor,
                                    ),
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
            );
          },
        );
      },
    );
  }

  Color _accentColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (order.status) {
      case CompletedOrderStatus.delivered:
        return scheme.primary;
      case CompletedOrderStatus.cancelled:
        return const Color(0xFFD32F2F);
      case CompletedOrderStatus.deliveryFailed:
        return const Color(0xFFD32F2F);
    }
  }

  String _statusText() {
    switch (order.status) {
      case CompletedOrderStatus.delivered:
        return 'مكتمل';
      case CompletedOrderStatus.cancelled:
        return 'ملغي';
      case CompletedOrderStatus.deliveryFailed:
        return 'ملغي';
    }
  }

  String _merchantEmoji() {
    final name = order.merchantName;
    if (name.contains('ماكدونالدز')) return '🍔';
    if (name.contains('بيتزا')) return '🍕';
    if (name.contains('ستاربكس')) return '☕';
    if (name.contains('كارفور')) return '🛒';
    if (name.contains('كنتاكي')) return '🍗';
    return '🏬';
  }

  String _paymentMethodLabel() {
    switch (order.paymentMethod) {
      case CompletedOrderPaymentMethod.cashOnDelivery:
        return 'كاش عند الاستلام';
      case CompletedOrderPaymentMethod.card:
        return 'فيزا';
      case CompletedOrderPaymentMethod.applePay:
        return 'Apple Pay';
      case CompletedOrderPaymentMethod.bankTransfer:
        return 'تحويل بنكي';
    }
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size10,
          color: color,
        ),
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  const _MetricColumn({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getMediumStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size10,
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size13,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _SheetSection extends StatelessWidget {
  const _SheetSection({
    required this.title,
    required this.child,
    required this.accentColor,
  });

  final String title;
  final Widget child;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: -8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size13,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size11,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size11,
              color: highlight ? const Color(0xFF2E7D32) : scheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroInfoTile extends StatelessWidget {
  const _HeroInfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(spacing: 3,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: accentColor),
          const SizedBox(height: 8),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size10,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size11,
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.item, required this.accentColor});

  final CompletedOrderItem item;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(_itemEmoji(item.name), style: const TextStyle(fontSize: 21)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size13,
                          color: AppColors.textPrimary,
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
                        color: AppColors.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'الكمية: ${item.quantity}',
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size10,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (item.note != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.note!,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _itemEmoji(String name) {
    if (name.contains('بيتزا')) return '🍕';
    if (name.contains('برجر') || name.contains('ماك')) return '🍔';
    if (name.contains('بطاطس')) return '🍟';
    if (name.contains('كوكا') || name.contains('عصير')) return '🥤';
    if (name.contains('قهوة') || name.contains('لاتيه')) return '☕';
    if (name.contains('كوكيز')) return '🍪';
    if (name.contains('حليب')) return '🥛';
    if (name.contains('بيض')) return '🥚';
    if (name.contains('دجاج') || name.contains('تويستر')) return '🍗';
    return '🍽️';
  }
}
