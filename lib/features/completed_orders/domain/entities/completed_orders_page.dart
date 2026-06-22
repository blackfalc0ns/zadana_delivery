import 'completed_order_entity.dart';

class CompletedOrdersPage {
  const CompletedOrdersPage({
    required this.orders,
    required this.totalCount,
    required this.page,
    required this.perPage,
    required this.hasMore,
  });

  final List<CompletedOrder> orders;
  final int totalCount;
  final int page;
  final int perPage;
  final bool hasMore;
}
