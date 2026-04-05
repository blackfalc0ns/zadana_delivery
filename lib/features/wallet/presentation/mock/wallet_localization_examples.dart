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

  String walletTransactionKindLabel(WalletTransactionKind kind) {
    switch (kind) {
      case WalletTransactionKind.delivery:
        return wallet_transaction_delivery;
      case WalletTransactionKind.withdrawal:
        return wallet_transaction_withdrawal;
      case WalletTransactionKind.bonus:
        return wallet_transaction_bonus;
      case WalletTransactionKind.adjustment:
        return wallet_transaction_adjustment;
    }
  }

  String walletTransactionStatusLabel(WalletTransactionStatus status) {
    switch (status) {
      case WalletTransactionStatus.completed:
        return wallet_status_completed;
      case WalletTransactionStatus.pending:
        return wallet_status_pending;
      case WalletTransactionStatus.failed:
        return wallet_status_failed;
    }
  }

  String walletPaymentMethodLabel(WalletPaymentMethodKind kind) {
    switch (kind) {
      case WalletPaymentMethodKind.bankAccount:
        return wallet_payment_bank_account;
      case WalletPaymentMethodKind.debitCard:
        return wallet_payment_debit_card;
      case WalletPaymentMethodKind.instantTransfer:
        return wallet_payment_instant_transfer;
    }
  }

  String walletBonusLabel(WalletBonusKind kind) {
    switch (kind) {
      case WalletBonusKind.weekend:
        return wallet_bonus_weekend;
      case WalletBonusKind.consistency:
        return wallet_bonus_consistency;
      case WalletBonusKind.peakHours:
        return wallet_bonus_peak_hours;
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
