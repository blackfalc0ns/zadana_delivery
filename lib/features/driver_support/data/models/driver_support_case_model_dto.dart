import 'package:zadana_delivery/features/driver_support/data/models/driver_support_attachment_dto.dart';
import 'package:zadana_delivery/features/driver_support/data/models/driver_support_case_activity_dto.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_entity.dart';

class DriverSupportCaseModelDto {
  const DriverSupportCaseModelDto({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.type,
    this.typeLabelAr,
    this.typeLabelEn,
    required this.status,
    this.statusLabelAr,
    this.statusLabelEn,
    required this.priority,
    this.priorityLabelAr,
    this.priorityLabelEn,
    required this.reasonCode,
    this.reasonLabelAr,
    this.reasonLabelEn,
    required this.message,
    required this.createdAt,
    this.adminNote,
    this.queue,
    this.queueLabelAr,
    this.queueLabelEn,
    this.decisionNotes,
    this.updatedAt,
    this.closedAt,
    this.attachments = const <DriverSupportAttachmentDto>[],
    this.activities = const <DriverSupportCaseActivityDto>[],
    this.waitingOnRole,
    this.waitingOnRoleLabel,
    this.allowedActions = const <String>[],
    this.costBearer,
    this.approvedRefundAmount,
    this.initiatorRole,
    this.initiatorRoleLabel,
    this.customerVisibleNote,
  });

  factory DriverSupportCaseModelDto.fromJson(Map<String, dynamic> json) {
    final orderIdValue = json['orderId'] ?? json['order_id'];
    final orderNumberValue = json['orderNumber'] ?? json['order_number'];
    final reasonCodeValue = json['reasonCode'] ?? json['reason_code'];
    final adminNoteValue = json['adminNote'] ?? json['admin_note'];
    final decisionNotesValue = json['decisionNotes'] ?? json['decision_notes'];
    final createdAtValue = json['createdAt'] ?? json['created_at'];
    final updatedAtValue = json['updatedAt'] ?? json['updated_at'];
    final closedAtValue = json['closedAt'] ?? json['closed_at'];
    final waitingOnRoleValue =
        json['waiting_on_role'] ?? json['waitingOnRole'];
    final waitingOnRoleLabelValue =
        json['waiting_on_role_label'] ?? json['waitingOnRoleLabel'];
    final allowedActionsValue =
        json['allowed_actions'] ?? json['allowedActions'];
    final costBearerValue = json['cost_bearer'] ?? json['costBearer'];
    final approvedRefundAmountValue =
        json['approved_refund_amount'] ?? json['approvedRefundAmount'];
    final initiatorRoleValue =
        json['initiator_role'] ?? json['initiatorRole'];
    final initiatorRoleLabelValue =
        json['initiator_role_label'] ?? json['initiatorRoleLabel'];
    final customerVisibleNoteValue =
        json['customer_visible_note'] ?? json['customerVisibleNote'];
    return DriverSupportCaseModelDto(
      id: json['id']?.toString() ?? '',
      orderId: orderIdValue?.toString() ?? '',
      orderNumber: orderNumberValue?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      typeLabelAr: (json['type_label_ar'] ?? json['typeLabelAr'])?.toString(),
      typeLabelEn: (json['type_label_en'] ?? json['typeLabelEn'])?.toString(),
      status: json['status']?.toString() ?? '',
      statusLabelAr: (json['status_label_ar'] ?? json['statusLabelAr'])
          ?.toString(),
      statusLabelEn: (json['status_label_en'] ?? json['statusLabelEn'])
          ?.toString(),
      priority: json['priority']?.toString() ?? '',
      priorityLabelAr: (json['priority_label_ar'] ?? json['priorityLabelAr'])
          ?.toString(),
      priorityLabelEn: (json['priority_label_en'] ?? json['priorityLabelEn'])
          ?.toString(),
      reasonCode: reasonCodeValue?.toString() ?? '',
      reasonLabelAr: (json['reason_label_ar'] ?? json['reasonLabelAr'])
          ?.toString(),
      reasonLabelEn: (json['reason_label_en'] ?? json['reasonLabelEn'])
          ?.toString(),
      message: json['message']?.toString() ?? '',
      adminNote: adminNoteValue?.toString(),
      queue: json['queue']?.toString(),
      queueLabelAr: (json['queue_label_ar'] ?? json['queueLabelAr'])
          ?.toString(),
      queueLabelEn: (json['queue_label_en'] ?? json['queueLabelEn'])
          ?.toString(),
      decisionNotes: decisionNotesValue?.toString(),
      createdAt: _dateTimeFromJson(createdAtValue),
      updatedAt: _dateTimeFromJson(updatedAtValue),
      closedAt: _dateTimeFromJson(closedAtValue),
      attachments: _attachmentsFromJson(json['attachments']),
      activities: _activitiesFromJson(json['activities']),
      waitingOnRole: waitingOnRoleValue?.toString(),
      waitingOnRoleLabel: waitingOnRoleLabelValue?.toString(),
      allowedActions: _stringListFromJson(allowedActionsValue),
      costBearer: costBearerValue?.toString(),
      approvedRefundAmount: _doubleFromJson(approvedRefundAmountValue),
      initiatorRole: initiatorRoleValue?.toString(),
      initiatorRoleLabel: initiatorRoleLabelValue?.toString(),
      customerVisibleNote: customerVisibleNoteValue?.toString(),
    );
  }

  final String id;
  final String orderId;
  final String orderNumber;
  final String type;
  final String? typeLabelAr;
  final String? typeLabelEn;
  final String status;
  final String? statusLabelAr;
  final String? statusLabelEn;
  final String priority;
  final String? priorityLabelAr;
  final String? priorityLabelEn;
  final String reasonCode;
  final String? reasonLabelAr;
  final String? reasonLabelEn;
  final String message;
  final String? adminNote;
  final String? queue;
  final String? queueLabelAr;
  final String? queueLabelEn;
  final String? decisionNotes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? closedAt;
  final List<DriverSupportAttachmentDto> attachments;
  final List<DriverSupportCaseActivityDto> activities;
  final String? waitingOnRole;
  final String? waitingOnRoleLabel;
  final List<String> allowedActions;
  final String? costBearer;
  final double? approvedRefundAmount;
  final String? initiatorRole;
  final String? initiatorRoleLabel;
  final String? customerVisibleNote;

  DriverSupportCaseEntity toEntity() {
    return DriverSupportCaseEntity(
      id: id,
      orderId: orderId,
      orderNumber: orderNumber,
      type: type,
      typeLabelAr: typeLabelAr,
      typeLabelEn: typeLabelEn,
      status: status,
      statusLabelAr: statusLabelAr,
      statusLabelEn: statusLabelEn,
      priority: priority,
      priorityLabelAr: priorityLabelAr,
      priorityLabelEn: priorityLabelEn,
      reasonCode: reasonCode,
      reasonLabelAr: reasonLabelAr,
      reasonLabelEn: reasonLabelEn,
      message: message,
      adminNote: adminNote,
      queue: queue,
      queueLabelAr: queueLabelAr,
      queueLabelEn: queueLabelEn,
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
      waitingOnRole: waitingOnRole,
      waitingOnRoleLabel: waitingOnRoleLabel,
      allowedActions: allowedActions,
      costBearer: costBearer,
      approvedRefundAmount: approvedRefundAmount,
      initiatorRole: initiatorRole,
      initiatorRoleLabel: initiatorRoleLabel,
      customerVisibleNote: customerVisibleNote,
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

  static List<String> _stringListFromJson(dynamic value) {
    if (value is! List) return const <String>[];
    return value
        .map((item) => item?.toString() ?? '')
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  static double? _doubleFromJson(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
