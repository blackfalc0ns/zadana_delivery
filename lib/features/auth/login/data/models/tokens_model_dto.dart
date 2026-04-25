import 'package:json_annotation/json_annotation.dart';

part 'tokens_model_dto.g.dart';

@JsonSerializable()
class TokensModelDto {
  const TokensModelDto({required this.accessToken, required this.refreshToken});

  factory TokensModelDto.fromJson(Map<String, dynamic> json) =>
      _$TokensModelDtoFromJson(json);

  final String accessToken;
  final String refreshToken;

  Map<String, dynamic> toJson() => _$TokensModelDtoToJson(this);
}
