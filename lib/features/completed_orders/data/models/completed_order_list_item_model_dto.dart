part of 'completed_order_model_dto.dart';

@JsonSerializable()
class CompletedOrderListItemModelDto {
  const CompletedOrderListItemModelDto({
    this.id = '',
    this.merchantName = '',
    this.merchantImageUrl,
    this.customerName = '',
    this.completedAtUtc = '',
    this.status = '',
    this.amount = 0,
    this.distanceKm = 0,
    this.paymentMethod = '',
    this.totalAmount = 0,
    this.codAmount = 0,
    this.deliveryAddress = '',
    this.items = const <CompletedOrderItemModelDto>[],
  });

  factory CompletedOrderListItemModelDto.fromJson(Map<String, dynamic> json) =>
      _$CompletedOrderListItemModelDtoFromJson(json);

  @JsonKey(fromJson: _stringFromJson)
  final String id;
  @JsonKey(fromJson: _stringFromJson)
  final String merchantName;
  @JsonKey(fromJson: _nullableStringFromJson)
  final String? merchantImageUrl;
  @JsonKey(fromJson: _stringFromJson)
  final String customerName;
  @JsonKey(fromJson: _stringFromJson)
  final String completedAtUtc;
  @JsonKey(fromJson: _stringFromJson)
  final String status;
  @JsonKey(fromJson: _doubleFromJson)
  final double amount;
  @JsonKey(fromJson: _doubleFromJson)
  final double distanceKm;
  @JsonKey(fromJson: _stringFromJson)
  final String paymentMethod;
  @JsonKey(fromJson: _doubleFromJson)
  final double totalAmount;
  @JsonKey(fromJson: _doubleFromJson)
  final double codAmount;
  @JsonKey(fromJson: _stringFromJson)
  final String deliveryAddress;
  @JsonKey(fromJson: _orderItemsFromJson)
  final List<CompletedOrderItemModelDto> items;

  Map<String, dynamic> toJson() => _$CompletedOrderListItemModelDtoToJson(this);
}
