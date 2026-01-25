class ExchangeRates {
  const ExchangeRates({
    required this.baseCurrency,
    required this.rates,
    required this.lastUpdated,
  });

  final String baseCurrency;
  final Map<String, double> rates;
  final DateTime lastUpdated;

  /// Get rate for a specific currency
  double getRate(String currency) {
    return rates[currency] ?? 1.0;
  }

  /// Convert amount from base currency to target currency
  double convert(double amount, String toCurrency) {
    return amount * getRate(toCurrency);
  }

  /// Get all available currency codes
  List<String> get availableCurrencies => rates.keys.toList();

  /// Check if rates are still valid (less than 24 hours old)
  bool get isValid {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);
    return difference.inHours < 24;
  }
}
