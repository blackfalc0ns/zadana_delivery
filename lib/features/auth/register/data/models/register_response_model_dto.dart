import 'package:json_annotation/json_annotation.dart';

import 'register_tokens_model_dto.dart';
import 'register_user_model_dto.dart';

part 'register_response_model_dto.g.dart';

@JsonSerializable()
class RegisterResponseModelDto {
  const RegisterResponseModelDto({
    this.tokens,
    this.user,
    this.isVerified = true,
    this.message,
  });

  factory RegisterResponseModelDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseModelDtoFromJson(json);

  final RegisterTokensModelDto? tokens;
  final RegisterUserModelDto? user;
  final bool isVerified;
  final String? message;

  Map<String, dynamic> toJson() => _$RegisterResponseModelDtoToJson(this);
}
