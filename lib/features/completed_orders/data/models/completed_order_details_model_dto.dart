part of 'completed_order_model_dto.dart';

@JsonSerializable()
class CompletedOrderDetailsModelDto {
  const CompletedOrderDetailsModelDto({
    this.id = '',
    this.assignmentId,
    this.orderNumber = '',
    this.merchantName = '',
    this.merchantPhone,
    this.customerName = '',
    this.customerPhone,
    this.pickupAddress,
    this.deliveryAddress = '',
    this.status = '',
    this.paymentMethod = '',
    this.amount = 0,
    this.totalAmount = 0,
    this.codAmount = 0,
    this.deliveryFee = 0,
    this.distanceKm = 0,
    this.completedAtUtc = '',
    this.items = const <CompletedOrderItemModelDto>[],
  });

  factory CompletedOrderDetailsModelDto.fromJson(Map<String, dynamic> json) =>
      _$CompletedOrderDetailsModelDtoFromJson(json);

  @JsonKey(fromJson: _stringFromJson)
  final String id;
  @JsonKey(fromJson: _nullableStringFromJson)
  final String? assignmentId;
  @JsonKey(fromJson: _stringFromJson)
  final String orderNumber;
  @JsonKey(fromJson: _stringFromJson)
  final String merchantName;
  @JsonKey(fromJson: _nullableStringFromJson)
  final String? merchantPhone;
  @JsonKey(fromJson: _stringFromJson)
  final String customerName;
  @JsonKey(fromJson: _nullableStringFromJson)
  final String? customerPhone;
  @JsonKey(fromJson: _nullableStringFromJson)
  final String? pickupAddress;
  @JsonKey(fromJson: _stringFromJson)
  final String deliveryAddress;
  @JsonKey(fromJson: _stringFromJson)
  final String status;
  @JsonKey(fromJson: _stringFromJson)
  final String paymentMethod;
  @JsonKey(fromJson: _doubleFromJson)
  final double amount;
  @JsonKey(fromJson: _doubleFromJson)
  final double totalAmount;
  @JsonKey(fromJson: _doubleFromJson)
  final double codAmount;
  @JsonKey(fromJson: _doubleFromJson)
  final double deliveryFee;
  @JsonKey(fromJson: _doubleFromJson)
  final double distanceKm;
  @JsonKey(fromJson: _stringFromJson)
  final String completedAtUtc;
  @JsonKey(fromJson: _orderItemsFromJson)
  final List<CompletedOrderItemModelDto> items;

  Map<String, dynamic> toJson() => _$CompletedOrderDetailsModelDtoToJson(this);
}
