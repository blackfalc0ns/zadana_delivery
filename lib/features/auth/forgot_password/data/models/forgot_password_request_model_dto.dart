class ForgotPasswordRequestModelDto {
  const ForgotPasswordRequestModelDto({required this.identifier});

  final String identifier;

  Map<String, dynamic> toJson() => {'identifier': identifier};
}
