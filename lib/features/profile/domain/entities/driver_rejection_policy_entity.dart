class DriverRejectionPolicyEntity {
  const DriverRejectionPolicyEntity({
    required this.dailyRejections,
    required this.dailyLimit,
    required this.remainingBeforeFreeze,
    required this.weeklyRejections,
    required this.weeklyLimit,
    required this.remainingBeforeWeeklyFreeze,
    required this.isFrozen,
    required this.restrictionMessage,
  });

  const DriverRejectionPolicyEntity.empty()
    : dailyRejections = 0,
      dailyLimit = 0,
      remainingBeforeFreeze = 0,
      weeklyRejections = 0,
      weeklyLimit = 0,
      remainingBeforeWeeklyFreeze = 0,
      isFrozen = false,
      restrictionMessage = null;

  final int dailyRejections;
  final int dailyLimit;
  final int remainingBeforeFreeze;
  final int weeklyRejections;
  final int weeklyLimit;
  final int remainingBeforeWeeklyFreeze;
  final bool isFrozen;
  final String? restrictionMessage;

  bool get hasData =>
      dailyLimit > 0 ||
      weeklyLimit > 0 ||
      dailyRejections > 0 ||
      weeklyRejections > 0 ||
      remainingBeforeFreeze > 0 ||
      remainingBeforeWeeklyFreeze > 0 ||
      isFrozen ||
      (restrictionMessage?.trim().isNotEmpty ?? false);
}
