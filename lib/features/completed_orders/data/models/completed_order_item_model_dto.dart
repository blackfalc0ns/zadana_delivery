part of 'completed_order_model_dto.dart';

@JsonSerializable()
class CompletedOrderItemModelDto {
  const CompletedOrderItemModelDto({
    this.name = '',
    this.quantity = 0,
    this.unitPrice = 0,
    this.lineTotal = 0,
    this.imageUrl,
  });

  factory CompletedOrderItemModelDto.fromJson(Map<String, dynamic> json) =>
      _$CompletedOrderItemModelDtoFromJson(json);

  @JsonKey(fromJson: _stringFromJson)
  final String name;
  @JsonKey(fromJson: _intFromJson)
  final int quantity;
  @JsonKey(fromJson: _doubleFromJson)
  final double unitPrice;
  @JsonKey(fromJson: _doubleFromJson)
  final double lineTotal;
  @JsonKey(fromJson: _nullableStringFromJson)
  final String? imageUrl;

  Map<String, dynamic> toJson() => _$CompletedOrderItemModelDtoToJson(this);
}
