import 'package:zadana_delivery/features/wallet/data/models/driver_wallet_withdrawal_request_model_dto.dart';

class DriverWalletWithdrawalsPageModelDto {
  const DriverWalletWithdrawalsPageModelDto({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  factory DriverWalletWithdrawalsPageModelDto.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawItems = json['items'];
    return DriverWalletWithdrawalsPageModelDto(
      items: rawItems is List
          ? rawItems
                .whereType<Map>()
                .map(
                  (item) => DriverWalletWithdrawalRequestModelDto.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList(growable: false)
          : const <DriverWalletWithdrawalRequestModelDto>[],
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
      totalCount: json['totalCount'] as int? ?? 0,
    );
  }

  final List<DriverWalletWithdrawalRequestModelDto> items;
  final int page;
  final int pageSize;
  final int totalCount;
}
