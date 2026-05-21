import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_delivery/features/auth/account_status/data/models/driver_account_status_model_dto.dart';

import 'tokens_model_dto.dart';
import 'user_model_dto.dart';

part 'login_response_model_dto.g.dart';

@JsonSerializable()
class LoginResponseModelDto {
  const LoginResponseModelDto({
    required this.tokens,
    required this.user,
    this.message = '',
    this.isVerified = true,
    this.driverStatus,
  });

  factory LoginResponseModelDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelDtoFromJson(json);

  final TokensModelDto tokens;
  final UserModelDto user;
  final String message;
  final bool isVerified;
  @JsonKey(fromJson: _driverStatusFromJson, toJson: _driverStatusToJson)
  final DriverAccountStatusModelDto? driverStatus;

  static DriverAccountStatusModelDto? _driverStatusFromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return DriverAccountStatusModelDto.fromJson(json);
    }
    if (json is Map) {
      return DriverAccountStatusModelDto.fromJson(
        Map<String, dynamic>.from(json),
      );
    }
    return null;
  }

  static Map<String, dynamic>? _driverStatusToJson(
    DriverAccountStatusModelDto? driverStatus,
  ) {
    if (driverStatus == null) return null;
    return {
      'driverId': driverStatus.driverId,
      'isOperational': driverStatus.isOperational,
      'canReceiveOrders': driverStatus.canReceiveOrders,
      'canGoAvailable': driverStatus.canGoAvailable,
      'isAvailable': driverStatus.isAvailable,
      'verificationStatus': driverStatus.verificationStatus,
      'accountStatus': driverStatus.accountStatus,
      'reviewedAtUtc': driverStatus.reviewedAtUtc,
      'reviewNote': driverStatus.reviewNote,
      'suspensionReason': driverStatus.suspensionReason,
      'primaryZoneId': driverStatus.primaryZoneId,
      'zoneName': driverStatus.zoneName,
      'message': driverStatus.message,
      'messageAr': driverStatus.messageAr,
      'messageEn': driverStatus.messageEn,
      'supportCta': driverStatus.supportCta == null
          ? null
          : {
              'endpoint': driverStatus.supportCta!.endpoint,
              'reasonType': driverStatus.supportCta!.reasonType,
              'labelAr': driverStatus.supportCta!.labelAr,
              'labelEn': driverStatus.supportCta!.labelEn,
            },
    };
  }

  Map<String, dynamic> toJson() => _$LoginResponseModelDtoToJson(this);
}
