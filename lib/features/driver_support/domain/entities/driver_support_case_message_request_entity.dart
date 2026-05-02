import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_attachment_entity.dart';

class DriverSupportCaseMessageRequestEntity {
  const DriverSupportCaseMessageRequestEntity({
    required this.reasonCode,
    required this.message,
    this.attachments = const <DriverSupportAttachmentEntity>[],
  });

  final String reasonCode;
  final String message;
  final List<DriverSupportAttachmentEntity> attachments;
}
