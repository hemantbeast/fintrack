class CurrencyRate {
  CurrencyRate({
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
  });

  final String fromCurrency;
  final String toCurrency;
  final double rate;

  double convert(double amount) => amount * rate;
}
