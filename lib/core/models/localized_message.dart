class LocalizedMessage {
  const LocalizedMessage({this.ar = '', this.en = '', this.fallback = ''});

  factory LocalizedMessage.fromJson(
    Map<String, dynamic> json, {
    String arKey = 'message_ar',
    String enKey = 'message_en',
    String fallbackKey = 'message',
  }) {
    return LocalizedMessage(
      ar: json[arKey]?.toString() ?? '',
      en: json[enKey]?.toString() ?? '',
      fallback: json[fallbackKey]?.toString() ?? '',
    );
  }

  final String ar;
  final String en;
  final String fallback;

  String resolve({required bool isArabic}) {
    final preferred = isArabic ? ar.trim() : en.trim();
    if (preferred.isNotEmpty) return preferred;

    final secondary = isArabic ? en.trim() : ar.trim();
    if (secondary.isNotEmpty) return secondary;

    return fallback.trim();
  }

  bool get isEmpty =>
      ar.trim().isEmpty && en.trim().isEmpty && fallback.trim().isEmpty;
}
