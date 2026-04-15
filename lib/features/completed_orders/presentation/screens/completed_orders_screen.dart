import 'package:flutter/material.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/spacing.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/core/widgets/custom_app_bar.dart';
import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/widgets/completed_order_card.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/widgets/completed_orders_empty_state.dart';
import 'package:zadana_delivery/features/completed_orders/presentation/widgets/completed_orders_filter_bar.dart';

class CompletedOrdersScreen extends StatefulWidget {
  const CompletedOrdersScreen({super.key});

  @override
  State<CompletedOrdersScreen> createState() => _CompletedOrdersScreenState();
}

class _CompletedOrdersScreenState extends State<CompletedOrdersScreen> {
  CompletedOrderStatus _selectedStatus = CompletedOrderStatus.delivered;

  late final List<CompletedOrder> _orders = _seedOrders()
    ..sort((a, b) => b.completedAt.compareTo(a.completedAt));

  List<CompletedOrder> get _filteredOrders {
    return _orders.where((order) => order.status == _selectedStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final filteredOrders = _filteredOrders;
    final totalDistance = filteredOrders.fold<double>(
      0,
      (sum, order) => sum + order.distanceKm,
    );

    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            CustomAppBar.modern(
              title: locale.completed_orders_title,
              onBackPressed: () => Navigator.of(context).maybePop(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
              child: CompletedOrdersFilterBar(
                selectedStatus: _selectedStatus,
                onStatusChanged: (status) =>
                    setState(() => _selectedStatus = status),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      value: '${filteredOrders.length}',
                      label: locale.completed_orders_summary_orders,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SummaryCard(
                      value: totalDistance.toStringAsFixed(1),
                      label: locale.completed_orders_summary_distance,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredOrders.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: CompletedOrdersEmptyState(
                        title: locale.completed_orders_no_results_title,
                        subtitle: locale.completed_orders_no_results_subtitle,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredOrders.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: Spacing.md),
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];
                        return CompletedOrderCard(order: order);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<CompletedOrder> _seedOrders() {
    return [
      CompletedOrder(
        id: '662531',
        merchantName: 'ماكدونالدز',
        customerName: 'أحمد',
        completedAt: DateTime(2026, 4, 4, 9, 15),
        status: CompletedOrderStatus.delivered,
        amount: 35,
        distanceKm: 3.2,
        paymentMethod: CompletedOrderPaymentMethod.card,
        deliveryAddress: '٣٢ شارع عباس العقاد، مدينة نصر، القاهرة',
        items: const [
          CompletedOrderItem(name: 'بيج ماك', quantity: 1),
          CompletedOrderItem(name: 'بطاطس كبيرة', quantity: 1),
          CompletedOrderItem(name: 'كوكاكولا', quantity: 1),
        ],
      ),
      CompletedOrder(
        id: '662532',
        merchantName: 'بيتزا هت',
        customerName: 'سارة علي',
        completedAt: DateTime(2026, 4, 4, 10, 40),
        status: CompletedOrderStatus.delivered,
        amount: 50,
        distanceKm: 5.8,
        paymentMethod: CompletedOrderPaymentMethod.cashOnDelivery,
        deliveryAddress: 'الحي السابع، مدينة نصر، القاهرة',
        items: const [
          CompletedOrderItem(name: 'بيتزا بيبروني وسط', quantity: 1),
          CompletedOrderItem(name: 'بطاطس ودجز', quantity: 1),
        ],
      ),
      CompletedOrder(
        id: '662533',
        merchantName: 'ستاربكس',
        customerName: 'محمود حسين',
        completedAt: DateTime(2026, 4, 3, 11, 20),
        status: CompletedOrderStatus.cancelled,
        amount: 0,
        distanceKm: 1.5,
        paymentMethod: CompletedOrderPaymentMethod.applePay,
        deliveryAddress: 'حي الياسمين، القاهرة الجديدة',
        items: const [
          CompletedOrderItem(name: 'لاتيه', quantity: 2),
          CompletedOrderItem(name: 'كوكيز', quantity: 1),
        ],
      ),
      CompletedOrder(
        id: '662534',
        merchantName: 'كارفور',
        customerName: 'نورا خالد',
        completedAt: DateTime(2026, 4, 3, 13),
        status: CompletedOrderStatus.delivered,
        amount: 60,
        distanceKm: 7.1,
        paymentMethod: CompletedOrderPaymentMethod.bankTransfer,
        deliveryAddress: 'شارع البطل أحمد عبد العزيز، الدقي، الجيزة',
        items: const [
          CompletedOrderItem(name: 'حليب', quantity: 2),
          CompletedOrderItem(name: 'بيض', quantity: 1),
          CompletedOrderItem(name: 'عصير برتقال', quantity: 3),
        ],
      ),
      CompletedOrder(
        id: '662535',
        merchantName: 'كنتاكي',
        customerName: 'عمر يسري',
        completedAt: DateTime(2026, 4, 2, 14, 30),
        status: CompletedOrderStatus.deliveryFailed,
        amount: 0,
        distanceKm: 2.4,
        paymentMethod: CompletedOrderPaymentMethod.card,
        deliveryAddress: 'اللوتس الجنوبي، القاهرة الجديدة',
        items: const [
          CompletedOrderItem(name: 'وجبة تويستر', quantity: 1),
          CompletedOrderItem(name: 'كول سلو', quantity: 1),
        ],
      ),
    ];
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: .5,
          color: scheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size17,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size10,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
