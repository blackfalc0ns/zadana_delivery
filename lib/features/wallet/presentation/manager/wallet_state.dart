import 'package:zadana_delivery/core/network/failures.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_summary_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_transaction_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_withdrawal_request_entity.dart';

class WalletState {
  const WalletState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.isSubmittingWithdrawal = false,
    this.cancellingWithdrawalId,
    this.isSubmittingPaymentMethod = false,
    this.isTransactionsLoading = false,
    this.isLoadingMoreTransactions = false,
    this.isWithdrawalsLoading = false,
    this.isLoadingMoreWithdrawals = false,
    this.activePaymentMethodId,
    this.summary,
    this.transactions = const <DriverWalletTransactionEntity>[],
    this.transactionsPage = 1,
    this.transactionsTotalCount = 0,
    this.withdrawals = const <DriverWalletWithdrawalRequestEntity>[],
    this.withdrawalsPage = 1,
    this.withdrawalsTotalCount = 0,
    this.paymentMethods = const <DriverPayoutMethodEntity>[],
    this.failure,
  });

  final bool isLoading;
  final bool isRefreshing;
  final bool isSubmittingWithdrawal;
  final String? cancellingWithdrawalId;
  final bool isSubmittingPaymentMethod;
  final bool isTransactionsLoading;
  final bool isLoadingMoreTransactions;
  final bool isWithdrawalsLoading;
  final bool isLoadingMoreWithdrawals;
  final String? activePaymentMethodId;
  final DriverWalletSummaryEntity? summary;
  final List<DriverWalletTransactionEntity> transactions;
  final int transactionsPage;
  final int transactionsTotalCount;
  final List<DriverWalletWithdrawalRequestEntity> withdrawals;
  final int withdrawalsPage;
  final int withdrawalsTotalCount;
  final List<DriverPayoutMethodEntity> paymentMethods;
  final Failure? failure;

  WalletState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isSubmittingWithdrawal,
    String? cancellingWithdrawalId,
    bool? isSubmittingPaymentMethod,
    bool? isTransactionsLoading,
    bool? isLoadingMoreTransactions,
    bool? isWithdrawalsLoading,
    bool? isLoadingMoreWithdrawals,
    String? activePaymentMethodId,
    DriverWalletSummaryEntity? summary,
    List<DriverWalletTransactionEntity>? transactions,
    int? transactionsPage,
    int? transactionsTotalCount,
    List<DriverWalletWithdrawalRequestEntity>? withdrawals,
    int? withdrawalsPage,
    int? withdrawalsTotalCount,
    List<DriverPayoutMethodEntity>? paymentMethods,
    Failure? failure,
    bool clearFailure = false,
    bool clearActivePaymentMethodId = false,
    bool clearCancellingWithdrawalId = false,
  }) {
    return WalletState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isSubmittingWithdrawal:
          isSubmittingWithdrawal ?? this.isSubmittingWithdrawal,
      cancellingWithdrawalId: clearCancellingWithdrawalId
          ? null
          : cancellingWithdrawalId ?? this.cancellingWithdrawalId,
      isSubmittingPaymentMethod:
          isSubmittingPaymentMethod ?? this.isSubmittingPaymentMethod,
      isTransactionsLoading:
          isTransactionsLoading ?? this.isTransactionsLoading,
      isLoadingMoreTransactions:
          isLoadingMoreTransactions ?? this.isLoadingMoreTransactions,
      isWithdrawalsLoading: isWithdrawalsLoading ?? this.isWithdrawalsLoading,
      isLoadingMoreWithdrawals:
          isLoadingMoreWithdrawals ?? this.isLoadingMoreWithdrawals,
      activePaymentMethodId: clearActivePaymentMethodId
          ? null
          : activePaymentMethodId ?? this.activePaymentMethodId,
      summary: summary ?? this.summary,
      transactions: transactions ?? this.transactions,
      transactionsPage: transactionsPage ?? this.transactionsPage,
      transactionsTotalCount:
          transactionsTotalCount ?? this.transactionsTotalCount,
      withdrawals: withdrawals ?? this.withdrawals,
      withdrawalsPage: withdrawalsPage ?? this.withdrawalsPage,
      withdrawalsTotalCount:
          withdrawalsTotalCount ?? this.withdrawalsTotalCount,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}
