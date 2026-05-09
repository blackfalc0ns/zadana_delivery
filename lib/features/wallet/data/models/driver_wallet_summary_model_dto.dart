import 'package:zadana_delivery/features/wallet/data/models/driver_payout_method_model_dto.dart';
import 'package:zadana_delivery/features/wallet/data/models/driver_wallet_transaction_model_dto.dart';
import 'package:zadana_delivery/features/wallet/data/models/driver_wallet_withdrawal_summary_model_dto.dart';

class DriverWalletSummaryModelDto {
  const DriverWalletSummaryModelDto({
    required this.currentBalance,
    required this.availableToWithdraw,
    required this.pendingBalance,
    required this.todayEarnings,
    required this.weekEarnings,
    required this.monthEarnings,
    required this.recentTransactions,
    required this.paymentMethods,
    required this.withdrawalSummary,
  });

  factory DriverWalletSummaryModelDto.fromJson(Map<String, dynamic> json) {
    return DriverWalletSummaryModelDto(
      currentBalance: _toDouble(json['currentBalance']),
      availableToWithdraw: _toDouble(json['availableToWithdraw']),
      pendingBalance: _toDouble(json['pendingBalance']),
      todayEarnings: _toDouble(json['todayEarnings']),
      weekEarnings: _toDouble(json['weekEarnings']),
      monthEarnings: _toDouble(json['monthEarnings']),
      recentTransactions: _toList(
        json['recentTransactions'],
        DriverWalletTransactionModelDto.fromJson,
      ),
      paymentMethods: _toList(
        json['paymentMethods'],
        DriverPayoutMethodModelDto.fromJson,
      ),
      withdrawalSummary: DriverWalletWithdrawalSummaryModelDto.fromJson(
        _normalizeMap(json['withdrawalSummary']),
      ),
    );
  }

  final double currentBalance;
  final double availableToWithdraw;
  final double pendingBalance;
  final double todayEarnings;
  final double weekEarnings;
  final double monthEarnings;
  final List<DriverWalletTransactionModelDto> recentTransactions;
  final List<DriverPayoutMethodModelDto> paymentMethods;
  final DriverWalletWithdrawalSummaryModelDto withdrawalSummary;

  static List<T> _toList<T>(
    dynamic value,
    T Function(Map<String, dynamic> json) parser,
  ) {
    if (value is List) {
      return value
          .whereType<Map>()
          .map((item) => parser(Map<String, dynamic>.from(item)))
          .toList(growable: false);
    }
    return List<T>.empty();
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static Map<String, dynamic> _normalizeMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }
}
