import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_attachment_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_activity_entity.dart';

class DriverSupportCaseEntity {
  const DriverSupportCaseEntity({
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
    this.attachments = const <DriverSupportAttachmentEntity>[],
    this.activities = const <DriverSupportCaseActivityEntity>[],
  });

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
  final List<DriverSupportAttachmentEntity> attachments;
  final List<DriverSupportCaseActivityEntity> activities;

  DriverSupportCaseEntity copyWith({
    String? id,
    String? orderId,
    String? orderNumber,
    String? type,
    String? status,
    String? priority,
    String? reasonCode,
    String? message,
    String? adminNote,
    String? queue,
    String? decisionNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? closedAt,
    List<DriverSupportAttachmentEntity>? attachments,
    List<DriverSupportCaseActivityEntity>? activities,
  }) {
    return DriverSupportCaseEntity(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      type: type ?? this.type,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      reasonCode: reasonCode ?? this.reasonCode,
      message: message ?? this.message,
      adminNote: adminNote ?? this.adminNote,
      queue: queue ?? this.queue,
      decisionNotes: decisionNotes ?? this.decisionNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      closedAt: closedAt ?? this.closedAt,
      attachments: attachments ?? this.attachments,
      activities: activities ?? this.activities,
    );
  }
}
