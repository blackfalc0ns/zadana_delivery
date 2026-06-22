class VerifyResetOtpRequestModelDto {
  const VerifyResetOtpRequestModelDto({
    required this.identifier,
    required this.otpCode,
  });

  final String identifier;
  final String otpCode;

  Map<String, dynamic> toJson() => {
    'identifier': identifier,
    'otpCode': otpCode,
  };
}
