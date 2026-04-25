class RefreshTokenResponseModelDto {
  const RefreshTokenResponseModelDto({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshTokenResponseModelDto.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponseModelDto(
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
    );
  }

  final String accessToken;
  final String refreshToken;
}
