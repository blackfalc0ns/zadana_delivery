import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_upsert_request_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_create_withdrawal_request_entity.dart';

sealed class WalletEvent {
  const WalletEvent();
}

class WalletLoadEvent extends WalletEvent {
  const WalletLoadEvent({this.refresh = false});

  final bool refresh;
}

class WalletClearErrorEvent extends WalletEvent {
  const WalletClearErrorEvent();
}

class WalletCreatePaymentMethodEvent extends WalletEvent {
  const WalletCreatePaymentMethodEvent(this.request);

  final DriverPayoutMethodUpsertRequestEntity request;
}

class WalletUpdatePaymentMethodEvent extends WalletEvent {
  const WalletUpdatePaymentMethodEvent(this.id, this.request);

  final String id;
  final DriverPayoutMethodUpsertRequestEntity request;
}

class WalletDeletePaymentMethodEvent extends WalletEvent {
  const WalletDeletePaymentMethodEvent(this.id);

  final String id;
}

class WalletMakePaymentMethodPrimaryEvent extends WalletEvent {
  const WalletMakePaymentMethodPrimaryEvent(this.id);

  final String id;
}

class WalletCreateWithdrawalEvent extends WalletEvent {
  const WalletCreateWithdrawalEvent(this.request);

  final DriverWalletCreateWithdrawalRequestEntity request;
}

class WalletLoadTransactionsEvent extends WalletEvent {
  const WalletLoadTransactionsEvent({this.refresh = false});

  final bool refresh;
}

class WalletLoadMoreTransactionsEvent extends WalletEvent {
  const WalletLoadMoreTransactionsEvent();
}

class WalletLoadWithdrawalsEvent extends WalletEvent {
  const WalletLoadWithdrawalsEvent({this.refresh = false});

  final bool refresh;
}

class WalletLoadMoreWithdrawalsEvent extends WalletEvent {
  const WalletLoadMoreWithdrawalsEvent();
}
