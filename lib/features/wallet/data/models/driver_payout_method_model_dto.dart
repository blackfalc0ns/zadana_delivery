class DriverPayoutMethodModelDto {
  const DriverPayoutMethodModelDto({
    required this.id,
    required this.type,
    required this.accountHolderName,
    required this.providerName,
    required this.maskedLabel,
    required this.isPrimary,
    required this.isVerified,
  });

  factory DriverPayoutMethodModelDto.fromJson(Map<String, dynamic> json) {
    return DriverPayoutMethodModelDto(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      accountHolderName: json['accountHolderName'] as String? ?? '',
      providerName: json['providerName'] as String? ?? '',
      maskedLabel: json['maskedLabel'] as String? ?? '',
      isPrimary: json['isPrimary'] as bool? ?? false,
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  final String id;
  final String type;
  final String accountHolderName;
  final String providerName;
  final String maskedLabel;
  final bool isPrimary;
  final bool isVerified;
}
