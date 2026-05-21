class VerifyDriverOtpRequestModelDto {
  const VerifyDriverOtpRequestModelDto({
    required this.identifier,
    required this.otpCode,
  });

  final String identifier;
  final String otpCode;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'identifier': identifier, 'otpCode': otpCode};
  }
}
