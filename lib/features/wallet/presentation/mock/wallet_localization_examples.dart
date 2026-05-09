import 'package:zadana_delivery/core/l10n/translations/app_localizations.dart';
import 'package:zadana_delivery/features/wallet/presentation/mock/wallet_fake_data.dart';

extension WalletLocalizedCopy on AppLocalizations {
  String walletPreviewLabel(WalletPreviewState state) {
    switch (state) {
      case WalletPreviewState.success:
        return wallet_state_success;
      case WalletPreviewState.empty:
        return wallet_state_empty;
      case WalletPreviewState.error:
        return wallet_state_error;
    }
  }

  String walletTransactionTypeLabel(String type) {
    switch (type.trim().toLowerCase()) {
      case 'orderrevenue':
        return wallet_transaction_delivery;
      case 'hold':
      case 'payout':
        return wallet_transaction_withdrawal;
      case 'adjustment':
        return wallet_transaction_adjustment;
      case 'release':
        return wallet_transaction_release;
      default:
        return wallet_transaction_bonus;
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
      case 'debitcard':
        return wallet_payment_debit_card;
      case 'instanttransfer':
      default:
        return wallet_payment_instant_transfer;
    }
  }

  String walletAlertActionLabel(WalletAlertAction action) {
    switch (action) {
      case WalletAlertAction.verify:
        return wallet_alert_action_verify;
      case WalletAlertAction.view:
        return wallet_alert_action_view;
      case WalletAlertAction.claim:
        return wallet_alert_action_claim;
    }
  }
}
