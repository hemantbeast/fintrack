import 'package:fintrack/features/settings/domain/entities/currency.dart';

/// Utility class for formatting currency amounts
class CurrencyFormatter {
  const CurrencyFormatter._();

  /// Format amount with currency symbol
  /// Example: 1000.50 -> ₹1,000.50 (for INR)
  static String format(double amount, {String currencyCode = 'INR'}) {
    final currency = Currency.maybeFromCode(currencyCode);
    final symbol = currency?.symbol ?? '₹';
    return '$symbol${_formatNumber(amount)}';
  }

  /// Format amount with currency code
  /// Example: 1000.50 -> INR 1,000.50
  static String formatWithCode(double amount, {String currencyCode = 'INR'}) {
    return '$currencyCode ${_formatNumber(amount)}';
  }

  /// Format amount with symbol and optional decimal places
  static String formatCompact(
    double amount, {
    String currencyCode = 'INR',
    int decimalPlaces = 0,
  }) {
    final currency = Currency.maybeFromCode(currencyCode);
    final symbol = currency?.symbol ?? '₹';
    return '$symbol${amount.toStringAsFixed(decimalPlaces)}';
  }

  /// Get currency symbol for a currency code
  static String getSymbol(String currencyCode) {
    final currency = Currency.maybeFromCode(currencyCode);
    return currency?.symbol ?? '₹';
  }

  /// Format number with thousand separators
  static String _formatNumber(double amount) {
    // Convert to string with 2 decimal places
    final parts = amount.toStringAsFixed(2).split('.');
    final wholePart = parts[0];
    final decimalPart = parts[1];

    // Add thousand separators
    final buffer = StringBuffer();
    var count = 0;

    for (var i = wholePart.length - 1; i >= 0; i--) {
      buffer.write(wholePart[i]);
      count++;

      if (count == 3 && i > 0) {
        buffer.write(',');
        count = 0;
      } else if (count == 2 && buffer.toString().contains(',') && i > 0) {
        buffer.write(',');
        count = 0;
      }
    }

    // Reverse and combine with decimal part
    final formatted = buffer.toString().split('').reversed.join();
    return '$formatted.$decimalPart';
  }
}
