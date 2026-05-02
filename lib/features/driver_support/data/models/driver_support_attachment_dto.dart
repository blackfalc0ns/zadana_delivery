import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_attachment_entity.dart';

class DriverSupportAttachmentDto {
  const DriverSupportAttachmentDto({
    required this.fileName,
    required this.fileUrl,
  });

  factory DriverSupportAttachmentDto.fromJson(Map<String, dynamic> json) {
    return DriverSupportAttachmentDto(
      fileName: json['fileName']?.toString() ?? '',
      fileUrl: json['fileUrl']?.toString() ?? '',
    );
  }

  final String fileName;
  final String fileUrl;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'fileName': fileName, 'fileUrl': fileUrl};
  }

  DriverSupportAttachmentEntity toEntity() {
    return DriverSupportAttachmentEntity(fileName: fileName, fileUrl: fileUrl);
  }
}
