import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_attachment_entity.dart';
import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_activity_entity.dart';

class DriverSupportCaseEntity {
  const DriverSupportCaseEntity({
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
    this.attachments = const <DriverSupportAttachmentEntity>[],
    this.activities = const <DriverSupportCaseActivityEntity>[],
    this.waitingOnRole,
    this.waitingOnRoleLabel,
    this.allowedActions = const <String>[],
    this.costBearer,
    this.approvedRefundAmount,
    this.initiatorRole,
    this.initiatorRoleLabel,
    this.customerVisibleNote,
  });

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
  final List<DriverSupportAttachmentEntity> attachments;
  final List<DriverSupportCaseActivityEntity> activities;
  final String? waitingOnRole;
  final String? waitingOnRoleLabel;
  final List<String> allowedActions;
  final String? costBearer;
  final double? approvedRefundAmount;
  final String? initiatorRole;
  final String? initiatorRoleLabel;
  final String? customerVisibleNote;

  String get normalizedType => type.trim().toLowerCase();

  bool get isAccountCase => normalizedType == 'driver_account';

  bool get hasOrderContext => orderId.trim().isNotEmpty;

  bool get isAwaitingDriverResponse =>
      (waitingOnRole ?? '').trim().toLowerCase() == 'driver';

  bool get canReply => allowedActions.contains('reply');

  bool get isDriverCostBearer =>
      (costBearer ?? '').trim().toLowerCase() == 'driver';

  bool get isClosed {
    final normalizedStatus = status.trim().toLowerCase();
    return normalizedStatus == 'resolved' ||
        normalizedStatus == 'rejected' ||
        normalizedStatus == 'approved';
  }

  String get displayReference {
    final normalizedOrderNumber = orderNumber.trim();
    if (normalizedOrderNumber.isNotEmpty) return normalizedOrderNumber;
    return id.trim();
  }

  DriverSupportCaseEntity copyWith({
    String? id,
    String? orderId,
    String? orderNumber,
    String? type,
    String? typeLabelAr,
    String? typeLabelEn,
    String? status,
    String? statusLabelAr,
    String? statusLabelEn,
    String? priority,
    String? priorityLabelAr,
    String? priorityLabelEn,
    String? reasonCode,
    String? reasonLabelAr,
    String? reasonLabelEn,
    String? message,
    String? adminNote,
    String? queue,
    String? queueLabelAr,
    String? queueLabelEn,
    String? decisionNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? closedAt,
    List<DriverSupportAttachmentEntity>? attachments,
    List<DriverSupportCaseActivityEntity>? activities,
    String? waitingOnRole,
    String? waitingOnRoleLabel,
    List<String>? allowedActions,
    String? costBearer,
    double? approvedRefundAmount,
    String? initiatorRole,
    String? initiatorRoleLabel,
    String? customerVisibleNote,
  }) {
    return DriverSupportCaseEntity(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      type: type ?? this.type,
      typeLabelAr: typeLabelAr ?? this.typeLabelAr,
      typeLabelEn: typeLabelEn ?? this.typeLabelEn,
      status: status ?? this.status,
      statusLabelAr: statusLabelAr ?? this.statusLabelAr,
      statusLabelEn: statusLabelEn ?? this.statusLabelEn,
      priority: priority ?? this.priority,
      priorityLabelAr: priorityLabelAr ?? this.priorityLabelAr,
      priorityLabelEn: priorityLabelEn ?? this.priorityLabelEn,
      reasonCode: reasonCode ?? this.reasonCode,
      reasonLabelAr: reasonLabelAr ?? this.reasonLabelAr,
      reasonLabelEn: reasonLabelEn ?? this.reasonLabelEn,
      message: message ?? this.message,
      adminNote: adminNote ?? this.adminNote,
      queue: queue ?? this.queue,
      queueLabelAr: queueLabelAr ?? this.queueLabelAr,
      queueLabelEn: queueLabelEn ?? this.queueLabelEn,
      decisionNotes: decisionNotes ?? this.decisionNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      closedAt: closedAt ?? this.closedAt,
      attachments: attachments ?? this.attachments,
      activities: activities ?? this.activities,
      waitingOnRole: waitingOnRole ?? this.waitingOnRole,
      waitingOnRoleLabel: waitingOnRoleLabel ?? this.waitingOnRoleLabel,
      allowedActions: allowedActions ?? this.allowedActions,
      costBearer: costBearer ?? this.costBearer,
      approvedRefundAmount: approvedRefundAmount ?? this.approvedRefundAmount,
      initiatorRole: initiatorRole ?? this.initiatorRole,
      initiatorRoleLabel: initiatorRoleLabel ?? this.initiatorRoleLabel,
      customerVisibleNote: customerVisibleNote ?? this.customerVisibleNote,
    );
  }
}
