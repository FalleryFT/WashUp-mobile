import 'package:intl/intl.dart';

class DateFormatter {
  static String formatShort(DateTime date) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  static String formatWithTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(date);
  }

  static String formatTimeOnly(DateTime date) {
    return DateFormat('HH:mm', 'id_ID').format(date);
  }

  static String fromIsoString(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '-';
    try {
      final parsed = DateTime.parse(isoString);
      return DateFormat('dd/MM/yyyy', 'id_ID').format(parsed);
    } catch (_) {
      return isoString;
    }
  }

  /// Alias used by screens: formats a nullable date string
  static String formatDate(String? value) => fromIsoString(value);

  /// Formats a date string with time
  static String formatDateTime(String? isoString) {
    if (isoString == null || isoString.isEmpty) return '-';
    try {
      final parsed = DateTime.parse(isoString);
      return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(parsed);
    } catch (_) {
      return isoString;
    }
  }
}
