class ForgotPasswordRequestModelDto {
  const ForgotPasswordRequestModelDto({
    required this.identifier,
    this.botChallengeToken,
  });

  final String identifier;

  /// Cloudflare Turnstile token sent as `X-Bot-Challenge-Token` header.
  final String? botChallengeToken;

  Map<String, dynamic> toJson() => {'identifier': identifier};
}
