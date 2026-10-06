import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String format(num? value) {
    if (value == null) return 'Rp 0';
    return _formatter.format(value);
  }

  static String formatFromString(String? value) {
    if (value == null || value.isEmpty) return 'Rp 0';
    if (value.startsWith('Rp')) return value;
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    final number = num.tryParse(digitsOnly) ?? 0;
    return format(number);
  }

  /// Compact format e.g. Rp 50rb / Rp 1,2jt
  static String shortFormat(num? value) {
    if (value == null) return 'Rp 0';
    if (value >= 1000000) {
      final juta = (value / 1000000);
      return 'Rp ${juta % 1 == 0 ? juta.toInt() : juta.toStringAsFixed(1)}jt';
    } else if (value >= 1000) {
      return 'Rp ${(value / 1000).round()}rb';
    }
    return format(value);
  }
}
