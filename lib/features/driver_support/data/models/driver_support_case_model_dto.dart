import 'package:zadana_delivery/features/driver_support/data/models/driver_support_attachment_dto.dart';
import 'package:zadana_delivery/features/driver_support/data/models/driver_support_case_activity_dto.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_entity.dart';

class DriverSupportCaseModelDto {
  const DriverSupportCaseModelDto({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.type,
    required this.status,
    required this.priority,
    required this.reasonCode,
    required this.message,
    required this.createdAt,
    this.adminNote,
    this.queue,
    this.decisionNotes,
    this.updatedAt,
    this.closedAt,
    this.attachments = const <DriverSupportAttachmentDto>[],
    this.activities = const <DriverSupportCaseActivityDto>[],
  });

  factory DriverSupportCaseModelDto.fromJson(Map<String, dynamic> json) {
    return DriverSupportCaseModelDto(
      id: json['id']?.toString() ?? '',
      orderId: json['orderId']?.toString() ?? '',
      orderNumber: json['orderNumber']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      priority: json['priority']?.toString() ?? '',
      reasonCode: json['reasonCode']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      adminNote: json['adminNote']?.toString(),
      queue: json['queue']?.toString(),
      decisionNotes: json['decisionNotes']?.toString(),
      createdAt: _dateTimeFromJson(json['createdAt']),
      updatedAt: _dateTimeFromJson(json['updatedAt']),
      closedAt: _dateTimeFromJson(json['closedAt']),
      attachments: _attachmentsFromJson(json['attachments']),
      activities: _activitiesFromJson(json['activities']),
    );
  }

  final String id;
  final String orderId;
  final String orderNumber;
  final String type;
  final String status;
  final String priority;
  final String reasonCode;
  final String message;
  final String? adminNote;
  final String? queue;
  final String? decisionNotes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? closedAt;
  final List<DriverSupportAttachmentDto> attachments;
  final List<DriverSupportCaseActivityDto> activities;

  DriverSupportCaseEntity toEntity() {
    return DriverSupportCaseEntity(
      id: id,
      orderId: orderId,
      orderNumber: orderNumber,
      type: type,
      status: status,
      priority: priority,
      reasonCode: reasonCode,
      message: message,
      adminNote: adminNote,
      queue: queue,
      decisionNotes: decisionNotes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      closedAt: closedAt,
      attachments: attachments
          .map((item) => item.toEntity())
          .toList(growable: false),
      activities: activities
          .map((item) => item.toEntity())
          .toList(growable: false),
    );
  }

  static List<DriverSupportAttachmentDto> _attachmentsFromJson(dynamic value) {
    if (value is! List) return const <DriverSupportAttachmentDto>[];
    return value
        .map((item) => DriverSupportAttachmentDto.fromJson(_asMap(item)))
        .toList(growable: false);
  }

  static List<DriverSupportCaseActivityDto> _activitiesFromJson(dynamic value) {
    if (value is! List) return const <DriverSupportCaseActivityDto>[];
    return value
        .map((item) => DriverSupportCaseActivityDto.fromJson(_asMap(item)))
        .toList(growable: false);
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const <String, dynamic>{};
  }

  static DateTime? _dateTimeFromJson(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
