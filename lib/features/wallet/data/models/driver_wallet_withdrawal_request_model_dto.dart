import 'package:zadana_delivery/features/wallet/data/models/driver_payout_method_model_dto.dart';

class DriverWalletWithdrawalRequestModelDto {
  const DriverWalletWithdrawalRequestModelDto({
    required this.id,
    required this.amount,
    required this.status,
    required this.transferReference,
    required this.failureReason,
    required this.createdAtUtc,
    required this.processedAtUtc,
    required this.paymentMethod,
  });

  factory DriverWalletWithdrawalRequestModelDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return DriverWalletWithdrawalRequestModelDto(
      id: json['id'] as String? ?? '',
      amount: _toDouble(json['amount']),
      status: json['status'] as String? ?? '',
      transferReference: json['transferReference'] as String?,
      failureReason: json['failureReason'] as String?,
      createdAtUtc: json['createdAtUtc'] as String? ?? '',
      processedAtUtc: json['processedAtUtc'] as String?,
      paymentMethod: DriverPayoutMethodModelDto.fromJson(
        _normalizeMap(json['paymentMethod']),
      ),
    );
  }

  final String id;
  final double amount;
  final String status;
  final String? transferReference;
  final String? failureReason;
  final String createdAtUtc;
  final String? processedAtUtc;
  final DriverPayoutMethodModelDto paymentMethod;

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
