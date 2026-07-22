import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_upsert_request_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_preference_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_create_withdrawal_request_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_summary_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_transactions_page_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_withdrawal_request_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_withdrawals_page_entity.dart';

abstract class WalletRepository {
  Future<ApiResult<DriverWalletSummaryEntity>> getWalletSummary();

  Future<ApiResult<DriverWalletTransactionsPageEntity>> getTransactions({
    int page = 1,
    int pageSize = 20,
  });

  Future<ApiResult<List<DriverPayoutMethodEntity>>> getPaymentMethods();

  Future<ApiResult<DriverPayoutMethodEntity>> createPaymentMethod(
    DriverPayoutMethodUpsertRequestEntity request,
  );

  Future<ApiResult<DriverPayoutMethodEntity>> updatePaymentMethod(
    String id,
    DriverPayoutMethodUpsertRequestEntity request,
  );

  Future<ApiResult<void>> deletePaymentMethod(String id);

  Future<ApiResult<DriverPayoutMethodEntity>> makePaymentMethodPrimary(
    String id,
  );

  Future<ApiResult<DriverWalletWithdrawalRequestEntity>> createWithdrawal(
    DriverWalletCreateWithdrawalRequestEntity request,
  );

  Future<ApiResult<DriverWalletWithdrawalsPageEntity>> getWithdrawals({
    int page = 1,
    int pageSize = 20,
  });

  Future<ApiResult<void>> cancelWithdrawal(String withdrawalId);
  Future<ApiResult<DriverPayoutPreferenceEntity>> getPayoutPreference();
  Future<ApiResult<DriverPayoutPreferenceEntity>> updatePayoutPreference(String payoutDay);
}
