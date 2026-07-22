import 'package:zadana_delivery/features/wallet/data/models/driver_payout_method_model_dto.dart';
import 'package:zadana_delivery/features/wallet/data/models/driver_wallet_transaction_model_dto.dart';
import 'package:zadana_delivery/features/wallet/data/models/driver_wallet_withdrawal_summary_model_dto.dart';

class DriverWalletSummaryModelDto {
  const DriverWalletSummaryModelDto({
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
    required this.payoutDay,
  });

  factory DriverWalletSummaryModelDto.fromJson(Map<String, dynamic> json) {
    final payload = _resolvePayload(json);
    return DriverWalletSummaryModelDto(
      currentBalance: _toDouble(payload['currentBalance']),
      availableToWithdraw: _toDouble(payload['availableToWithdraw']),
      pendingBalance: _toDouble(payload['pendingBalance']),
      codOwedBalance: _toDouble(payload['codOwedBalance']),
      netWithdrawable: _toDouble(payload['netWithdrawable']),
      todayEarnings: _toDouble(payload['todayEarnings']),
      weekEarnings: _toDouble(payload['weekEarnings']),
      monthEarnings: _toDouble(payload['monthEarnings']),
      recentTransactions: _toList(
        payload['recentTransactions'] ??
            payload['transactions'] ??
            payload['recentWalletTransactions'],
        DriverWalletTransactionModelDto.fromJson,
      ),
      paymentMethods: _toList(
        payload['paymentMethods'] ??
            payload['methods'] ??
            payload['payoutMethods'],
        DriverPayoutMethodModelDto.fromJson,
      ),
      withdrawalSummary: DriverWalletWithdrawalSummaryModelDto.fromJson(
        _normalizeMap(
          payload['withdrawalSummary'] ??
              payload['withdrawalsSummary'] ??
              payload['withdrawalStats'],
        ),
      ),
      payoutDay: payload['payoutDay']?.toString() ?? '',
    );
  }

  final double currentBalance;
  final double availableToWithdraw;
  final double pendingBalance;
  final double codOwedBalance;
  final double netWithdrawable;
  final double todayEarnings;
  final double weekEarnings;
  final double monthEarnings;
  final List<DriverWalletTransactionModelDto> recentTransactions;
  final List<DriverPayoutMethodModelDto> paymentMethods;
  final DriverWalletWithdrawalSummaryModelDto withdrawalSummary;
  final String payoutDay;

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

  static Map<String, dynamic> _resolvePayload(Map<String, dynamic> json) {
    for (final key in const ['data', 'result', 'wallet', 'summary']) {
      final nested = _normalizeMap(json[key]);
      if (nested.isNotEmpty) {
        return nested;
      }
    }
    return json;
  }
}
