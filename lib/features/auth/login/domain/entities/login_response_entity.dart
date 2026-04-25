import 'package:zadana_delivery/features/auth/account_status/domain/entities/driver_account_status_entity.dart';

import 'tokens_entity.dart';
import 'user_entity.dart';

class LoginResponseEntity {
  const LoginResponseEntity({
    required this.tokens,
    required this.user,
    required this.message,
    required this.isVerified,
    this.driverStatus,
  });

  final TokensEntity tokens;
  final UserEntity user;
  final String message;
  final bool isVerified;
  final DriverAccountStatusEntity? driverStatus;
}
