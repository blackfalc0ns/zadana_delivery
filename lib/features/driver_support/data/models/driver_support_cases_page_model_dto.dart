import 'package:zadana_delivery/features/driver_support/data/models/driver_support_case_model_dto.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_cases_page_entity.dart';

class DriverSupportCasesPageModelDto {
  const DriverSupportCasesPageModelDto({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.hasMore,
  });

  factory DriverSupportCasesPageModelDto.fromJson(Map<String, dynamic> json) {
    final items = _itemsFromJson(
      json['items'] ?? json['data'] ?? json['cases'] ?? json['results'],
    );
    final page = _intFromJson(json['page']);
    final pageSize = _intFromJson(json['pageSize'] ?? json['perPage']) == 0
        ? 20
        : _intFromJson(json['pageSize'] ?? json['perPage']);
    final total = _intFromJson(json['total']);
    final hasMore = json.containsKey('hasMore')
        ? _boolFromJson(json['hasMore'])
        : page * pageSize < total;
    return DriverSupportCasesPageModelDto(
      items: items,
      page: page == 0 ? 1 : page,
      pageSize: pageSize,
      total: total,
      hasMore: hasMore,
    );
  }

  final List<DriverSupportCaseModelDto> items;
  final int page;
  final int pageSize;
  final int total;
  final bool hasMore;

  DriverSupportCasesPageEntity toEntity() {
    return DriverSupportCasesPageEntity(
      items: items.map((item) => item.toEntity()).toList(growable: false),
      page: page,
      pageSize: pageSize,
      total: total,
      hasMore: hasMore,
    );
  }

  static List<DriverSupportCaseModelDto> _itemsFromJson(dynamic value) {
    if (value is! List) return const <DriverSupportCaseModelDto>[];
    return value
        .map((item) => DriverSupportCaseModelDto.fromJson(_asMap(item)))
        .toList(growable: false);
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }

  static int _intFromJson(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _boolFromJson(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }
}
