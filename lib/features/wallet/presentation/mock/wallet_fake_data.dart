import 'package:flutter/material.dart';

enum WalletPreviewState { success, empty, error }

enum WalletTransactionStatus { completed, pending, failed }

enum WalletTransactionKind { delivery, withdrawal, bonus, adjustment }

enum WalletPaymentMethodKind { bankAccount, debitCard, instantTransfer }

enum WalletBonusKind { weekend, consistency, peakHours }

enum WalletAlertAction { verify, view, claim }

class WalletSnapshot {
  const WalletSnapshot({
    required this.currentBalance,
    required this.availableToWithdraw,
    required this.pendingBalance,
    required this.todayEarnings,
    required this.weekEarnings,
    required this.monthEarnings,
    required this.transactions,
    required this.paymentMethods,
    required this.bonuses,
    required this.alerts,
  });

  final double currentBalance;
  final double availableToWithdraw;
  final double pendingBalance;
  final double todayEarnings;
  final double weekEarnings;
  final double monthEarnings;
  final List<WalletTransactionItem> transactions;
  final List<WalletPaymentMethodItem> paymentMethods;
  final List<WalletBonusItem> bonuses;
  final List<WalletAlertItem> alerts;
}

class WalletTransactionItem {
  const WalletTransactionItem({
    required this.kind,
    required this.status,
    required this.amount,
    required this.date,
    required this.reference,
    required this.note,
  });

  final WalletTransactionKind kind;
  final WalletTransactionStatus status;
  final double amount;
  final DateTime date;
  final String reference;
  final String note;
}

class WalletPaymentMethodItem {
  const WalletPaymentMethodItem({
    required this.kind,
    required this.maskedLabel,
    required this.isPrimary,
    required this.isVerified,
    required this.icon,
  });

  final WalletPaymentMethodKind kind;
  final String maskedLabel;
  final bool isPrimary;
  final bool isVerified;
  final IconData icon;
}

class WalletBonusItem {
  const WalletBonusItem({
    required this.kind,
    required this.progress,
    required this.deadline,
    required this.rewardLabel,
  });

  final WalletBonusKind kind;
  final double progress;
  final DateTime deadline;
  final String rewardLabel;
}

class WalletAlertItem {
  const WalletAlertItem({
    required this.titleKey,
    required this.subtitleKey,
    required this.action,
  });

  final String titleKey;
  final String subtitleKey;
  final WalletAlertAction action;
}

class WalletFakeData {
  WalletFakeData._();

  static final WalletSnapshot success = WalletSnapshot(
    currentBalance: 2480.75,
    availableToWithdraw: 1875.20,
    pendingBalance: 605.55,
    todayEarnings: 320.50,
    weekEarnings: 1465.75,
    monthEarnings: 5380.00,
    transactions: [
      WalletTransactionItem(
        kind: WalletTransactionKind.delivery,
        status: WalletTransactionStatus.completed,
        amount: 145.00,
        date: DateTime(2026, 4, 4, 18, 10),
        reference: '#TRX-9021',
        note: '6 completed trips',
      ),
      WalletTransactionItem(
        kind: WalletTransactionKind.withdrawal,
        status: WalletTransactionStatus.pending,
        amount: -500.00,
        date: DateTime(2026, 4, 4, 13, 20),
        reference: '#TRX-9012',
        note: 'Settlement in progress',
      ),
      WalletTransactionItem(
        kind: WalletTransactionKind.bonus,
        status: WalletTransactionStatus.completed,
        amount: 220.00,
        date: DateTime(2026, 4, 3, 22, 35),
        reference: '#TRX-8990',
        note: 'Peak-hours reward',
      ),
      WalletTransactionItem(
        kind: WalletTransactionKind.adjustment,
        status: WalletTransactionStatus.failed,
        amount: -35.00,
        date: DateTime(2026, 4, 2, 12, 15),
        reference: '#TRX-8944',
        note: 'Temporary reconciliation hold',
      ),
    ],
    paymentMethods: const [
      WalletPaymentMethodItem(
        kind: WalletPaymentMethodKind.bankAccount,
        maskedLabel: 'National Bank 1842',
        isPrimary: true,
        isVerified: true,
        icon: Icons.account_balance_rounded,
      ),
      WalletPaymentMethodItem(
        kind: WalletPaymentMethodKind.debitCard,
        maskedLabel: 'Visa 4421',
        isPrimary: false,
        isVerified: true,
        icon: Icons.credit_card_rounded,
      ),
      WalletPaymentMethodItem(
        kind: WalletPaymentMethodKind.instantTransfer,
        maskedLabel: 'InstaPay driver@bank',
        isPrimary: false,
        isVerified: false,
        icon: Icons.bolt_rounded,
      ),
    ],
    bonuses: [
      WalletBonusItem(
        kind: WalletBonusKind.weekend,
        progress: 0.72,
        deadline: DateTime(2026, 4, 6),
        rewardLabel: '+180',
      ),
      WalletBonusItem(
        kind: WalletBonusKind.consistency,
        progress: 0.54,
        deadline: DateTime(2026, 4, 8),
        rewardLabel: '+240',
      ),
      WalletBonusItem(
        kind: WalletBonusKind.peakHours,
        progress: 0.88,
        deadline: DateTime(2026, 4, 5),
        rewardLabel: '+120',
      ),
    ],
    alerts: const [
      WalletAlertItem(
        titleKey: 'wallet_alert_verification_title',
        subtitleKey: 'wallet_alert_verification_subtitle',
        action: WalletAlertAction.verify,
      ),
      WalletAlertItem(
        titleKey: 'wallet_alert_payout_title',
        subtitleKey: 'wallet_alert_payout_subtitle',
        action: WalletAlertAction.view,
      ),
      WalletAlertItem(
        titleKey: 'wallet_alert_incentive_title',
        subtitleKey: 'wallet_alert_incentive_subtitle',
        action: WalletAlertAction.claim,
      ),
    ],
  );

  static const WalletSnapshot empty = WalletSnapshot(
    currentBalance: 0,
    availableToWithdraw: 0,
    pendingBalance: 0,
    todayEarnings: 0,
    weekEarnings: 0,
    monthEarnings: 0,
    transactions: [],
    paymentMethods: [],
    bonuses: [],
    alerts: [],
  );
}
