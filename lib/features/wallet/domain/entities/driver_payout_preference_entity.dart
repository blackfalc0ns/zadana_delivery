class DriverPayoutPreferenceEntity {
  const DriverPayoutPreferenceEntity({
    required this.payoutDay,
    required this.availablePayoutDays,
  });

  final String payoutDay;
  final List<String> availablePayoutDays;
}
