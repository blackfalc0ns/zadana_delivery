import 'package:json_annotation/json_annotation.dart';

part 'register_tokens_model_dto.g.dart';

@JsonSerializable()
class RegisterTokensModelDto {
  const RegisterTokensModelDto({this.accessToken, this.refreshToken});

  factory RegisterTokensModelDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterTokensModelDtoFromJson(json);

  final String? accessToken;
  final String? refreshToken;

  Map<String, dynamic> toJson() => _$RegisterTokensModelDtoToJson(this);
}
