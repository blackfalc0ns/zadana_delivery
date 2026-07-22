import 'package:zadana_delivery/features/wallet/data/models/driver_payout_method_model_dto.dart';
import 'package:zadana_delivery/features/wallet/data/models/driver_wallet_summary_model_dto.dart';
import 'package:zadana_delivery/features/wallet/data/models/driver_wallet_transactions_page_model_dto.dart';
import 'package:zadana_delivery/features/wallet/data/models/driver_wallet_withdrawal_request_model_dto.dart';
import 'package:zadana_delivery/features/wallet/data/models/driver_wallet_withdrawals_page_model_dto.dart';

abstract class WalletRemoteDataSource {
  Future<DriverWalletSummaryModelDto> getWalletSummary();

  Future<DriverWalletTransactionsPageModelDto> getTransactions({
    int page = 1,
    int pageSize = 20,
  });

  Future<List<DriverPayoutMethodModelDto>> getPaymentMethods();

  Future<DriverPayoutMethodModelDto> createPaymentMethod(
    Map<String, dynamic> request,
  );

  Future<DriverPayoutMethodModelDto> updatePaymentMethod(
    String id,
    Map<String, dynamic> request,
  );

  Future<void> deletePaymentMethod(String id);

  Future<DriverPayoutMethodModelDto> makePaymentMethodPrimary(String id);

  Future<DriverWalletWithdrawalRequestModelDto> createWithdrawal(
    Map<String, dynamic> request,
  );

  Future<DriverWalletWithdrawalsPageModelDto> getWithdrawals({
    int page = 1,
    int pageSize = 20,
  });

  Future<void> cancelWithdrawal(String withdrawalId);

  Future<Map<String, dynamic>> getPayoutPreference();
  Future<Map<String, dynamic>> updatePayoutPreference(String payoutDay);
}
