part of 'completed_order_model_dto.dart';

@JsonSerializable()
class CompletedOrdersResponseModelDto {
  const CompletedOrdersResponseModelDto({
    this.items = const <CompletedOrderListItemModelDto>[],
    this.totalCount = 0,
  });

  factory CompletedOrdersResponseModelDto.fromJson(Map<String, dynamic> json) =>
      _$CompletedOrdersResponseModelDtoFromJson(json);

  @JsonKey(fromJson: _listItemsFromJson)
  final List<CompletedOrderListItemModelDto> items;
  @JsonKey(fromJson: _intFromJson)
  final int totalCount;

  Map<String, dynamic> toJson() =>
      _$CompletedOrdersResponseModelDtoToJson(this);

  static List<CompletedOrderListItemModelDto> _listItemsFromJson(
    dynamic value,
  ) {
    if (value is List) {
      return value
          .map((item) => CompletedOrderListItemModelDto.fromJson(_asMap(item)))
          .toList(growable: false);
    }
    return const <CompletedOrderListItemModelDto>[];
  }
}
