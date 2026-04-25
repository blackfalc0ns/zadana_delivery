import 'package:json_annotation/json_annotation.dart';

part 'completed_order_model_dto.g.dart';
part 'completed_order_item_model_dto.dart';
part 'completed_order_list_item_model_dto.dart';
part 'completed_order_details_model_dto.dart';
part 'completed_orders_response_model_dto.dart';

List<CompletedOrderItemModelDto> _orderItemsFromJson(dynamic value) {
  if (value is List) {
    return value
        .map((item) => CompletedOrderItemModelDto.fromJson(_asMap(item)))
        .toList(growable: false);
  }
  return const <CompletedOrderItemModelDto>[];
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return const <String, dynamic>{};
}

String _stringFromJson(dynamic value) => value?.toString() ?? '';

String? _nullableStringFromJson(dynamic value) {
  final parsed = value?.toString().trim();
  if (parsed == null || parsed.isEmpty) return null;
  return parsed;
}

int _intFromJson(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _doubleFromJson(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
