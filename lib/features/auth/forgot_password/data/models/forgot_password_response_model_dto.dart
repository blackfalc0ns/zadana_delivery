class ForgotPasswordResponseModelDto {
  const ForgotPasswordResponseModelDto({required this.message});

  factory ForgotPasswordResponseModelDto.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponseModelDto(
      message: json['message']?.toString() ?? '',
    );
  }

  final String message;
}
