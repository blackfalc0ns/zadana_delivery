import 'package:zadana_delivery/features/wallet/data/models/driver_payout_method_model_dto.dart';
import 'package:zadana_delivery/features/wallet/data/models/driver_wallet_summary_model_dto.dart';
import 'package:zadana_delivery/features/wallet/data/models/driver_wallet_transaction_model_dto.dart';
import 'package:zadana_delivery/features/wallet/data/models/driver_wallet_transactions_page_model_dto.dart';
import 'package:zadana_delivery/features/wallet/data/models/driver_wallet_withdrawal_request_model_dto.dart';
import 'package:zadana_delivery/features/wallet/data/models/driver_wallet_withdrawal_summary_model_dto.dart';
import 'package:zadana_delivery/features/wallet/data/models/driver_wallet_withdrawals_page_model_dto.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_upsert_request_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_create_withdrawal_request_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_summary_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_transaction_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_transactions_page_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_withdrawal_request_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_withdrawal_summary_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_withdrawals_page_entity.dart';

extension DriverWalletTransactionMapper on DriverWalletTransactionModelDto {
  DriverWalletTransactionEntity toEntity() {
    return DriverWalletTransactionEntity(
      id: id,
      type: type,
      direction: direction,
      amount: amount,
      description: description,
      referenceType: referenceType,
      referenceId: referenceId,
      createdAt: DateTime.tryParse(createdAtUtc)?.toLocal() ?? DateTime(0),
    );
  }
}

extension DriverPayoutMethodMapper on DriverPayoutMethodModelDto {
  DriverPayoutMethodEntity toEntity() {
    return DriverPayoutMethodEntity(
      id: id,
      type: type,
      accountHolderName: accountHolderName,
      providerName: providerName,
      maskedLabel: maskedLabel,
      isPrimary: isPrimary,
      isVerified: isVerified,
    );
  }
}

extension DriverWalletWithdrawalSummaryMapper
    on DriverWalletWithdrawalSummaryModelDto {
  DriverWalletWithdrawalSummaryEntity toEntity() {
    return DriverWalletWithdrawalSummaryEntity(
      pendingCount: pendingCount,
      pendingAmount: pendingAmount,
      totalRequests: totalRequests,
    );
  }
}

extension DriverWalletSummaryMapper on DriverWalletSummaryModelDto {
  DriverWalletSummaryEntity toEntity() {
    return DriverWalletSummaryEntity(
      currentBalance: currentBalance,
      availableToWithdraw: availableToWithdraw,
      pendingBalance: pendingBalance,
      todayEarnings: todayEarnings,
      weekEarnings: weekEarnings,
      monthEarnings: monthEarnings,
      recentTransactions: recentTransactions
          .map((item) => item.toEntity())
          .toList(growable: false),
      paymentMethods: paymentMethods
          .map((item) => item.toEntity())
          .toList(growable: false),
      withdrawalSummary: withdrawalSummary.toEntity(),
    );
  }
}

extension DriverWalletTransactionsPageMapper
    on DriverWalletTransactionsPageModelDto {
  DriverWalletTransactionsPageEntity toEntity() {
    return DriverWalletTransactionsPageEntity(
      items: items.map((item) => item.toEntity()).toList(growable: false),
      page: page,
      pageSize: pageSize,
      totalCount: totalCount,
    );
  }
}

extension DriverWalletWithdrawalRequestMapper
    on DriverWalletWithdrawalRequestModelDto {
  DriverWalletWithdrawalRequestEntity toEntity() {
    return DriverWalletWithdrawalRequestEntity(
      id: id,
      amount: amount,
      status: status,
      transferReference: transferReference,
      failureReason: failureReason,
      createdAt: DateTime.tryParse(createdAtUtc)?.toLocal() ?? DateTime(0),
      processedAt: processedAtUtc == null
          ? null
          : DateTime.tryParse(processedAtUtc!)?.toLocal(),
      paymentMethod: paymentMethod.toEntity(),
    );
  }
}

extension DriverWalletWithdrawalsPageMapper
    on DriverWalletWithdrawalsPageModelDto {
  DriverWalletWithdrawalsPageEntity toEntity() {
    return DriverWalletWithdrawalsPageEntity(
      items: items.map((item) => item.toEntity()).toList(growable: false),
      page: page,
      pageSize: pageSize,
      totalCount: totalCount,
    );
  }
}

extension DriverPayoutMethodUpsertRequestMapper
    on DriverPayoutMethodUpsertRequestEntity {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type.trim(),
      'accountHolderName': accountHolderName.trim(),
      'accountIdentifier': accountIdentifier.trim(),
      'providerName': providerName.trim(),
      if (isPrimary != null) 'isPrimary': isPrimary,
    };
  }
}

extension DriverWalletCreateWithdrawalRequestMapper
    on DriverWalletCreateWithdrawalRequestEntity {
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (paymentMethodId != null && paymentMethodId!.trim().isNotEmpty)
        'paymentMethodId': paymentMethodId!.trim(),
      'amount': amount,
    };
  }
}
