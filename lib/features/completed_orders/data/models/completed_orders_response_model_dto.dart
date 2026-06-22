part of 'completed_order_model_dto.dart';

@JsonSerializable()
class CompletedOrdersResponseModelDto {
  const CompletedOrdersResponseModelDto({
    this.items = const <CompletedOrderListItemModelDto>[],
    this.totalCount = 0,
    this.page = 1,
    this.perPage = 20,
    this.hasMore = false,
  });

  factory CompletedOrdersResponseModelDto.fromJson(Map<String, dynamic> json) =>
      _$CompletedOrdersResponseModelDtoFromJson(json);

  @JsonKey(fromJson: _listItemsFromJson)
  final List<CompletedOrderListItemModelDto> items;
  @JsonKey(fromJson: _intFromJson)
  final int totalCount;
  @JsonKey(fromJson: _intFromJson)
  final int page;
  @JsonKey(fromJson: _intFromJson)
  final int perPage;
  @JsonKey(fromJson: _boolFromJson)
  final bool hasMore;

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
