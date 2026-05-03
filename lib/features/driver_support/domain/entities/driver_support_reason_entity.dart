class DriverSupportReasonEntity {
  const DriverSupportReasonEntity({
    required this.code,
    required this.labelAr,
    required this.labelEn,
    required this.requiresNote,
  });

  final String code;
  final String labelAr;
  final String labelEn;
  final bool requiresNote;
}
