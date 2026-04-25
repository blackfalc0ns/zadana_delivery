class RefreshTokenResponseEntity {
  const RefreshTokenResponseEntity({
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;
}
