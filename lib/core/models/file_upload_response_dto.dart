import 'package:json_annotation/json_annotation.dart';

part 'file_upload_response_dto.g.dart';

@JsonSerializable()
class FileUploadResponseDto {
  const FileUploadResponseDto({required this.url});

  factory FileUploadResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FileUploadResponseDtoFromJson(json);

  final String url;

  Map<String, dynamic> toJson() => _$FileUploadResponseDtoToJson(this);
}
