import 'package:json_annotation/json_annotation.dart';
import 'package:zadana_delivery/features/auth/account_status/data/models/driver_account_status_model_dto.dart';

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
    this.driverStatus,
  });

  factory RegisterResponseModelDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseModelDtoFromJson(json);

  final RegisterTokensModelDto? tokens;
  final RegisterUserModelDto? user;
  final bool isVerified;
  final String? message;
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
      'gateStatus': driverStatus.gateStatus,
      'isOperational': driverStatus.isOperational,
      'canReceiveOrders': driverStatus.canReceiveOrders,
      'canReceiveOffers': driverStatus.canReceiveOffers,
      'canGoAvailable': driverStatus.canGoAvailable,
      'isAvailable': driverStatus.isAvailable,
      'verificationStatus': driverStatus.verificationStatus,
      'accountStatus': driverStatus.accountStatus,
      'enforcementLevel': driverStatus.enforcementLevel,
      'reviewedAtUtc': driverStatus.reviewedAtUtc,
      'reviewNote': driverStatus.reviewNote,
      'reviewNoteAr': driverStatus.reviewNoteAr,
      'reviewNoteEn': driverStatus.reviewNoteEn,
      'suspensionReason': driverStatus.suspensionReason,
      'restrictionMessage': driverStatus.restrictionMessage,
      'restrictionMessageAr': driverStatus.restrictionMessageAr,
      'restrictionMessageEn': driverStatus.restrictionMessageEn,
      'primaryZoneId': driverStatus.primaryZoneId,
      'zoneName': driverStatus.zoneName,
      'message': driverStatus.message,
      'messageAr': driverStatus.messageAr,
      'messageEn': driverStatus.messageEn,
      'policyIsFrozen': driverStatus.policyIsFrozen,
    };
  }

  Map<String, dynamic> toJson() => _$RegisterResponseModelDtoToJson(this);
}
