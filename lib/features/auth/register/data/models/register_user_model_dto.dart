import 'package:json_annotation/json_annotation.dart';

part 'register_user_model_dto.g.dart';

@JsonSerializable()
class RegisterUserModelDto {
  const RegisterUserModelDto({
    this.id,
    this.fullName,
    this.email,
    this.phone,
    this.role,
    this.profilePhotoUrl,
    this.favoritesCount,
  });

  factory RegisterUserModelDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterUserModelDtoFromJson(json);

  final String? id;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? role;
  final String? profilePhotoUrl;
  final int? favoritesCount;

  Map<String, dynamic> toJson() => _$RegisterUserModelDtoToJson(this);
}
