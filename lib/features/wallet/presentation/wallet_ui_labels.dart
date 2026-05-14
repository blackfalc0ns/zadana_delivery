import 'package:zadana_delivery/core/l10n/translations/app_localizations.dart';

extension WalletUiLabels on AppLocalizations {
  String walletTransactionTypeLabel(String type) {
    switch (type.trim().toLowerCase()) {
      case 'orderrevenue':
        return wallet_transaction_delivery;
      case 'payout':
        return wallet_transaction_withdrawal;
      case 'refund':
        return wallet_transaction_refund;
      case 'settlement':
        return wallet_transaction_settlement;
      case 'adjustment':
        return wallet_transaction_adjustment;
      case 'cashcollected':
        return wallet_transaction_cash_collected;
      case 'hold':
        return wallet_transaction_hold;
      case 'release':
        return wallet_transaction_release;
      case 'credit':
        return wallet_transaction_credit;
      case 'debit':
        return wallet_transaction_debit;
      default:
        return wallet_transaction_generic;
    }
  }

  String walletWithdrawalStatusLabel(String status) {
    switch (status.trim().toLowerCase()) {
      case 'pending':
        return wallet_status_pending;
      case 'processing':
        return wallet_status_processing;
      case 'paid':
        return wallet_status_paid;
      case 'cancelled':
        return wallet_status_cancelled;
      case 'failed':
      default:
        return wallet_status_failed;
    }
  }

  String walletPaymentMethodLabel(String type) {
    switch (type.trim().toLowerCase()) {
      case 'bankaccount':
        return wallet_payment_bank_account;
      case 'mobilewallet':
        return wallet_payment_mobile_wallet;
      case 'debitcard':
        return wallet_payment_debit_card;
      case 'instanttransfer':
      default:
        return wallet_payment_instant_transfer;
    }
  }
}
