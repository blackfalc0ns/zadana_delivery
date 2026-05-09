import 'package:zadana_delivery/features/wallet/data/models/driver_wallet_transaction_model_dto.dart';

class DriverWalletTransactionsPageModelDto {
  const DriverWalletTransactionsPageModelDto({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
  });

  factory DriverWalletTransactionsPageModelDto.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawItems = json['items'];
    return DriverWalletTransactionsPageModelDto(
      items: rawItems is List
          ? rawItems
                .whereType<Map>()
                .map(
                  (item) => DriverWalletTransactionModelDto.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList(growable: false)
          : const <DriverWalletTransactionModelDto>[],
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
      totalCount: json['totalCount'] as int? ?? 0,
    );
  }

  final List<DriverWalletTransactionModelDto> items;
  final int page;
  final int pageSize;
  final int totalCount;
}
