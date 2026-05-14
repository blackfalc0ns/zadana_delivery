class DriverRejectionPolicyModelDto {
  const DriverRejectionPolicyModelDto({
    required this.dailyRejections,
    required this.dailyLimit,
    required this.remainingBeforeFreeze,
    required this.weeklyRejections,
    required this.weeklyLimit,
    required this.remainingBeforeWeeklyFreeze,
    required this.isFrozen,
    required this.restrictionMessage,
  });

  factory DriverRejectionPolicyModelDto.fromJson(Map<String, dynamic> json) {
    return DriverRejectionPolicyModelDto(
      dailyRejections: _readInt(json['dailyRejections']),
      dailyLimit: _readInt(json['dailyLimit']),
      remainingBeforeFreeze: _readInt(json['remainingBeforeFreeze']),
      weeklyRejections: _readInt(json['weeklyRejections']),
      weeklyLimit: _readInt(json['weeklyLimit']),
      remainingBeforeWeeklyFreeze: _readInt(
        json['remainingBeforeWeeklyFreeze'],
      ),
      isFrozen: json['isFrozen'] == true,
      restrictionMessage: json['restrictionMessage']?.toString(),
    );
  }

  final int dailyRejections;
  final int dailyLimit;
  final int remainingBeforeFreeze;
  final int weeklyRejections;
  final int weeklyLimit;
  final int remainingBeforeWeeklyFreeze;
  final bool isFrozen;
  final String? restrictionMessage;

  static int _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
