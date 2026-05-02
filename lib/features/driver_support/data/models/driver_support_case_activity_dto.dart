import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_activity_entity.dart';

class DriverSupportCaseActivityDto {
  const DriverSupportCaseActivityDto({
    required this.id,
    required this.type,
    required this.message,
    required this.createdAt,
    this.actorName,
  });

  factory DriverSupportCaseActivityDto.fromJson(Map<String, dynamic> json) {
    return DriverSupportCaseActivityDto(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      message: (json['message'] ?? json['description'])?.toString() ?? '',
      createdAt: _dateTimeFromJson(json['createdAt']),
      actorName: json['actorName']?.toString(),
    );
  }

  final String id;
  final String type;
  final String message;
  final DateTime? createdAt;
  final String? actorName;

  DriverSupportCaseActivityEntity toEntity() {
    return DriverSupportCaseActivityEntity(
      id: id,
      type: type,
      message: message,
      createdAt: createdAt,
      actorName: actorName,
    );
  }

  static DateTime? _dateTimeFromJson(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
