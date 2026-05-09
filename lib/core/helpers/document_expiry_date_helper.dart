import 'package:intl/intl.dart';

class DocumentExpiryDateHelper {
  const DocumentExpiryDateHelper._();

  static final DateFormat _dateOnlyFormat = DateFormat('yyyy-MM-dd');

  static DateTime? tryParse(String rawValue) {
    final normalized = rawValue.trim();
    if (normalized.isEmpty) return null;

    final direct = DateTime.tryParse(normalized);
    if (direct != null) {
      return DateTime(direct.year, direct.month, direct.day);
    }

    try {
      final parsed = _dateOnlyFormat.parseStrict(normalized);
      return DateTime(parsed.year, parsed.month, parsed.day);
    } catch (_) {
      return null;
    }
  }

  static String toFormValue(String rawValue) {
    final parsed = tryParse(rawValue);
    if (parsed == null) return rawValue.trim();
    return _dateOnlyFormat.format(parsed);
  }

  static String toBackendValue(String rawValue) {
    final parsed = tryParse(rawValue);
    if (parsed == null) return rawValue.trim();
    return DateTime.utc(
      parsed.year,
      parsed.month,
      parsed.day,
    ).toIso8601String();
  }

  static bool isExpired(String rawValue, {DateTime? now}) {
    final parsed = tryParse(rawValue);
    if (parsed == null) return false;
    final reference = now ?? DateTime.now();
    final today = DateTime(reference.year, reference.month, reference.day);
    return parsed.isBefore(today);
  }

  static String formatForDisplay(String rawValue, {String fallback = '--'}) {
    final parsed = tryParse(rawValue);
    if (parsed == null) {
      return rawValue.trim().isEmpty ? fallback : rawValue.trim();
    }
    return _dateOnlyFormat.format(parsed);
  }
}
