class VerifyResetOtpResponseModelDto {
  const VerifyResetOtpResponseModelDto({required this.resetToken});

  factory VerifyResetOtpResponseModelDto.fromJson(Map<String, dynamic> json) {
    return VerifyResetOtpResponseModelDto(
      resetToken: json['resetToken']?.toString() ?? '',
    );
  }

  final String resetToken;
}
