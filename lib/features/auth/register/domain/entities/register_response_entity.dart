import 'package:zadana_delivery/features/auth/account_status/domain/entities/driver_account_status_entity.dart';
import 'package:zadana_delivery/features/auth/login/domain/entities/tokens_entity.dart';

import 'register_user_entity.dart';

class RegisterResponseEntity {
  const RegisterResponseEntity({
    required this.message,
    required this.isVerified,
    this.user,
    this.tokens,
    this.driverStatus,
  });

  final String message;
  final bool isVerified;
  final RegisterUserEntity? user;
  final TokensEntity? tokens;
  final DriverAccountStatusEntity? driverStatus;
}
