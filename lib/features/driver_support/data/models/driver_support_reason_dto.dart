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
      requiresNote: _boolFromJson(
        json['requires_note'] ?? json['requiresNote'],
      ),
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

  static bool _boolFromJson(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final normalized = value?.toString().trim().toLowerCase() ?? '';
    return normalized == 'true' || normalized == '1';
  }
}
