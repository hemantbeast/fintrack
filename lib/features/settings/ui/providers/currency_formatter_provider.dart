import 'package:fintrack/features/settings/domain/entities/currency_formatter.dart';
import 'package:fintrack/features/settings/ui/providers/settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider that gives access to the currency formatter with user's preferred currency
final currencyFormatterProvider = Provider<CurrencyFormatterHelper>((ref) {
  final settingsState = ref.watch(settingsProvider);

  return settingsState.screenData.when(
    data: (data) => CurrencyFormatterHelper(data.preferences.currency),
    loading: () => const CurrencyFormatterHelper('INR'),
    error: (_, _) => const CurrencyFormatterHelper('INR'),
  );
});

/// Helper class that binds the currency code to formatting methods
class CurrencyFormatterHelper {
  const CurrencyFormatterHelper(this.currencyCode);

  final String currencyCode;

  /// Format amount with currency symbol
  String format(double amount) {
    return CurrencyFormatter.format(amount, currencyCode: currencyCode);
  }

  /// Format amount with currency code
  String formatWithCode(double amount) {
    return CurrencyFormatter.formatWithCode(amount, currencyCode: currencyCode);
  }

  /// Format amount with symbol and optional decimal places
  String formatCompact(double amount, {int decimalPlaces = 0}) {
    return CurrencyFormatter.formatCompact(
      amount,
      currencyCode: currencyCode,
      decimalPlaces: decimalPlaces,
    );
  }

  /// Get currency symbol
  String get symbol => CurrencyFormatter.getSymbol(currencyCode);
}
