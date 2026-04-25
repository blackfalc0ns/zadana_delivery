import 'package:json_annotation/json_annotation.dart';

part 'user_model_dto.g.dart';

@JsonSerializable()
class UserModelDto {
  const UserModelDto({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.favoritesCount = 0,
  });

  factory UserModelDto.fromJson(Map<String, dynamic> json) =>
      _$UserModelDtoFromJson(json);

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final int favoritesCount;

  Map<String, dynamic> toJson() => _$UserModelDtoToJson(this);
}
