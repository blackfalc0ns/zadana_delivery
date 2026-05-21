class ResendDriverOtpRequestModelDto {
  const ResendDriverOtpRequestModelDto({required this.identifier});

  final String identifier;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'identifier': identifier};
  }
}
