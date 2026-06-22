import 'package:zadana_delivery/features/completed_orders/domain/entities/completed_order.dart';

sealed class CompletedOrdersEvent {
  const CompletedOrdersEvent();
}

class CompletedOrdersLoadEvent extends CompletedOrdersEvent {
  const CompletedOrdersLoadEvent({this.refresh = false});

  final bool refresh;
}

class CompletedOrdersLoadMoreEvent extends CompletedOrdersEvent {
  const CompletedOrdersLoadMoreEvent();
}

class CompletedOrdersSelectStatusEvent extends CompletedOrdersEvent {
  const CompletedOrdersSelectStatusEvent(this.status);

  final CompletedOrderStatus status;
}

class CompletedOrdersClearErrorEvent extends CompletedOrdersEvent {
  const CompletedOrdersClearErrorEvent();
}

class CompletedOrdersLoadDetailsEvent extends CompletedOrdersEvent {
  const CompletedOrdersLoadDetailsEvent(this.orderId);

  final String orderId;
}
