class ResetPasswordResponseModelDto {
  const ResetPasswordResponseModelDto({required this.message});

  factory ResetPasswordResponseModelDto.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponseModelDto(
      message: json['message']?.toString() ?? '',
    );
  }

  final String message;
}
