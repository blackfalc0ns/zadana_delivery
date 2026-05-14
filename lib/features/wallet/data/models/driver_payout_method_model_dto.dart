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
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      accountHolderName: json['accountHolderName']?.toString() ?? '',
      providerName: json['providerName']?.toString() ?? '',
      maskedLabel: json['maskedLabel']?.toString() ?? '',
      isPrimary: _toBool(json['isPrimary']),
      isVerified: _toBool(json['isVerified']),
    );
  }

  final String id;
  final String type;
  final String accountHolderName;
  final String providerName;
  final String maskedLabel;
  final bool isPrimary;
  final bool isVerified;

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) return value.trim().toLowerCase() == 'true';
    return false;
  }
}
