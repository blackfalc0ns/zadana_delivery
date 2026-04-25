import 'package:zadana_delivery/features/auth/account_status/data/mapper/driver_account_status_mapper.dart';

import '../../domain/entities/login_request_entity.dart';
import '../../domain/entities/login_response_entity.dart';
import '../../domain/entities/tokens_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../models/login_request_model_dto.dart';
import '../models/login_response_model_dto.dart';
import '../models/user_model_dto.dart';

extension LoginRequestEntityMapper on LoginRequestEntity {
  LoginRequestModelDto toDto() {
    return LoginRequestModelDto(
      identifier: identifier.trim(),
      password: password,
    );
  }
}

extension LoginResponseDtoMapper on LoginResponseModelDto {
  LoginResponseEntity toEntity({UserModelDto? fallbackUser}) {
    final resolvedUser = fallbackUser ?? user;

    return LoginResponseEntity(
      tokens: TokensEntity(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      ),
      user: UserEntity(
        id: resolvedUser.id,
        fullName: resolvedUser.fullName,
        email: resolvedUser.email,
        phone: resolvedUser.phone,
        role: resolvedUser.role,
        favoritesCount: resolvedUser.favoritesCount,
      ),
      message: message,
      isVerified: isVerified,
      driverStatus: driverStatus?.toEntity(),
    );
  }
}
