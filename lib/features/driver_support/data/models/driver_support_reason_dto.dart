import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_reason_entity.dart';

class DriverSupportReasonDto {
  const DriverSupportReasonDto({
    required this.code,
    required this.labelAr,
    required this.labelEn,
    required this.requiresNote,
  });

  factory DriverSupportReasonDto.fromJson(Map<String, dynamic> json) {
    return DriverSupportReasonDto(
      code: json['code']?.toString() ?? '',
      labelAr: (json['label_ar'] ?? json['labelAr'])?.toString() ?? '',
      labelEn: (json['label_en'] ?? json['labelEn'])?.toString() ?? '',
      requiresNote:
          (json['requires_note'] ?? json['requiresNote']) == true,
    );
  }

  final String code;
  final String labelAr;
  final String labelEn;
  final bool requiresNote;

  DriverSupportReasonEntity toEntity() {
    return DriverSupportReasonEntity(
      code: code,
      labelAr: labelAr,
      labelEn: labelEn,
      requiresNote: requiresNote,
    );
  }
}
