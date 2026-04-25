class RefreshTokenRequestModelDto {
  const RefreshTokenRequestModelDto({required this.refreshToken});

  final String refreshToken;

  Map<String, dynamic> toJson() => {'refreshToken': refreshToken};
}
