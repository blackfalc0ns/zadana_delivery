import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/features/wallet/data/data_source/wallet_remote_data_source.dart';
import 'package:zadana_delivery/features/wallet/data/mapper/wallet_mapper.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_upsert_request_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_preference_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_create_withdrawal_request_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_summary_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_transactions_page_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_transfer_proof_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_withdrawal_request_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_withdrawals_page_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/repo/wallet_repository.dart';

@LazySingleton(as: WalletRepository)
class WalletRepositoryImpl implements WalletRepository {
  const WalletRepositoryImpl(this._remoteDataSource);

  final WalletRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<DriverWalletSummaryEntity>> getWalletSummary() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getWalletSummary();
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<DriverWalletTransactionsPageEntity>> getTransactions({
    int page = 1,
    int pageSize = 20,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getTransactions(
        page: page,
        pageSize: pageSize,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<List<DriverPayoutMethodEntity>>> getPaymentMethods() {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getPaymentMethods();
      return response.map((item) => item.toEntity()).toList(growable: false);
    });
  }

  @override
  Future<ApiResult<DriverPayoutMethodEntity>> createPaymentMethod(
    DriverPayoutMethodUpsertRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.createPaymentMethod(
        request.toJson(),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<DriverPayoutMethodEntity>> updatePaymentMethod(
    String id,
    DriverPayoutMethodUpsertRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.updatePaymentMethod(
        id,
        request.toJson(),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<void>> deletePaymentMethod(String id) {
    return safeApiCall(() async {
      await _remoteDataSource.deletePaymentMethod(id);
    });
  }

  @override
  Future<ApiResult<DriverPayoutMethodEntity>> makePaymentMethodPrimary(
    String id,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.makePaymentMethodPrimary(id);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<DriverWalletWithdrawalRequestEntity>> createWithdrawal(
    DriverWalletCreateWithdrawalRequestEntity request,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.createWithdrawal(
        request.toJson(),
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<DriverWalletWithdrawalsPageEntity>> getWithdrawals({
    int page = 1,
    int pageSize = 20,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.getWithdrawals(
        page: page,
        pageSize: pageSize,
      );
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<void>> cancelWithdrawal(String withdrawalId) {
    return safeApiCall(() => _remoteDataSource.cancelWithdrawal(withdrawalId));
  }

  @override
  Future<ApiResult<DriverWalletTransferProofEntity>>
  downloadWithdrawalTransferProof(String withdrawalId) {
    return safeApiCall(
      () => _remoteDataSource.downloadWithdrawalTransferProof(withdrawalId),
    );
  }

  @override
  Future<ApiResult<DriverPayoutPreferenceEntity>> getPayoutPreference() =>
      safeApiCall(() async {
        final json = await _remoteDataSource.getPayoutPreference();
        return _payoutPreference(json);
      });
  @override
  Future<ApiResult<DriverPayoutPreferenceEntity>> updatePayoutPreference(
    String payoutDay,
  ) => safeApiCall(() async {
    final json = await _remoteDataSource.updatePayoutPreference(payoutDay);
    return _payoutPreference(json);
  });
  DriverPayoutPreferenceEntity _payoutPreference(Map<String, dynamic> json) =>
      DriverPayoutPreferenceEntity(
        payoutDay: json['payoutDay']?.toString() ?? '',
        availablePayoutDays: (json['availablePayoutDays'] as List? ?? const [])
            .map((e) => e.toString())
            .toList(growable: false),
      );
}
