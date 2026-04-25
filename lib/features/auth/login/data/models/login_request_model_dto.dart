import 'package:json_annotation/json_annotation.dart';

part 'login_request_model_dto.g.dart';

@JsonSerializable()
class LoginRequestModelDto {
  const LoginRequestModelDto({
    required this.identifier,
    required this.password,
  });

  factory LoginRequestModelDto.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelDtoFromJson(json);

  final String identifier;
  final String password;

  Map<String, dynamic> toJson() => _$LoginRequestModelDtoToJson(this);
}
