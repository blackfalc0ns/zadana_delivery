import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_activity_entity.dart';

class DriverSupportCaseActivityDto {
  const DriverSupportCaseActivityDto({
    required this.id,
    required this.type,
    this.typeLabelAr,
    this.typeLabelEn,
    this.titleAr,
    this.titleEn,
    required this.message,
    required this.createdAt,
    this.actorName,
    this.actorRoleLabelAr,
    this.actorRoleLabelEn,
  });

  factory DriverSupportCaseActivityDto.fromJson(Map<String, dynamic> json) {
    final actionValue = json['type'] ?? json['action'];
    final noteValue =
        (json['message'] ?? json['description'] ?? json['note'])
            ?.toString()
            .trim() ??
        '';
    return DriverSupportCaseActivityDto(
      id:
          json['id']?.toString() ??
          json['created_at']?.toString() ??
          json['createdAt']?.toString() ??
          actionValue?.toString() ??
          '',
      type: actionValue?.toString() ?? '',
      typeLabelAr: json['action_label_ar']?.toString(),
      typeLabelEn: json['action_label_en']?.toString(),
      titleAr: json['title_ar']?.toString(),
      titleEn: json['title_en']?.toString(),
      message: noteValue,
      createdAt: _dateTimeFromJson(json['createdAt'] ?? json['created_at']),
      actorName: (json['actorName'] ?? json['actor_name'] ?? json['actor_role'])
          ?.toString(),
      actorRoleLabelAr: json['actor_role_label_ar']?.toString(),
      actorRoleLabelEn: json['actor_role_label_en']?.toString(),
    );
  }

  final String id;
  final String type;
  final String? typeLabelAr;
  final String? typeLabelEn;
  final String? titleAr;
  final String? titleEn;
  final String message;
  final DateTime? createdAt;
  final String? actorName;
  final String? actorRoleLabelAr;
  final String? actorRoleLabelEn;

  DriverSupportCaseActivityEntity toEntity() {
    return DriverSupportCaseActivityEntity(
      id: id,
      type: type,
      typeLabelAr: typeLabelAr,
      typeLabelEn: typeLabelEn,
      titleAr: titleAr,
      titleEn: titleEn,
      message: message,
      createdAt: createdAt,
      actorName: actorName,
      actorRoleLabelAr: actorRoleLabelAr,
      actorRoleLabelEn: actorRoleLabelEn,
    );
  }

  static DateTime? _dateTimeFromJson(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
