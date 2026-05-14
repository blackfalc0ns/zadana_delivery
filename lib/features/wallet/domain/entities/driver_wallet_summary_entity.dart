import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_transaction_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_withdrawal_summary_entity.dart';

class DriverWalletSummaryEntity {
  const DriverWalletSummaryEntity({
    required this.currentBalance,
    required this.availableToWithdraw,
    required this.pendingBalance,
    required this.codOwedBalance,
    required this.netWithdrawable,
    required this.todayEarnings,
    required this.weekEarnings,
    required this.monthEarnings,
    required this.recentTransactions,
    required this.paymentMethods,
    required this.withdrawalSummary,
  });

  final double currentBalance;
  final double availableToWithdraw;
  final double pendingBalance;
  final double codOwedBalance;
  final double netWithdrawable;
  final double todayEarnings;
  final double weekEarnings;
  final double monthEarnings;
  final List<DriverWalletTransactionEntity> recentTransactions;
  final List<DriverPayoutMethodEntity> paymentMethods;
  final DriverWalletWithdrawalSummaryEntity withdrawalSummary;

  bool get isEmpty =>
      currentBalance == 0 &&
      availableToWithdraw == 0 &&
      pendingBalance == 0 &&
      codOwedBalance == 0 &&
      netWithdrawable == 0 &&
      todayEarnings == 0 &&
      weekEarnings == 0 &&
      monthEarnings == 0 &&
      recentTransactions.isEmpty &&
      paymentMethods.isEmpty &&
      withdrawalSummary.totalRequests == 0;
}
