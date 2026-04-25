import 'register_user_entity.dart';

class RegisterResponseEntity {
  const RegisterResponseEntity({
    required this.message,
    required this.isVerified,
    this.user,
  });

  final String message;
  final bool isVerified;
  final RegisterUserEntity? user;
}
