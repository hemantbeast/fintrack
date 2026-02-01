/// Enumeration of supported currencies with their symbols
enum Currency {
  usd('USD', r'$', 'US Dollar'),
  eur('EUR', '€', 'Euro'),
  gbp('GBP', '£', 'British Pound'),
  jpy('JPY', '¥', 'Japanese Yen'),
  cad('CAD', r'C$', 'Canadian Dollar'),
  aud('AUD', r'A$', 'Australian Dollar'),
  chf('CHF', 'CHF', 'Swiss Franc'),
  cny('CNY', '¥', 'Chinese Yuan'),
  inr('INR', '₹', 'Indian Rupee'),
  brl('BRL', r'R$', 'Brazilian Real'),
  mxn('MXN', r'$', 'Mexican Peso'),
  sgd('SGD', r'S$', 'Singapore Dollar'),
  krw('KRW', '₩', 'South Korean Won'),
  rub('RUB', '₽', 'Russian Ruble'),
  zar('ZAR', 'R', 'South African Rand'),
  sek('SEK', 'kr', 'Swedish Krona'),
  nok('NOK', 'kr', 'Norwegian Krone'),
  dkk('DKK', 'kr', 'Danish Krone'),
  pln('PLN', 'zł', 'Polish Zloty'),
  thb('THB', '฿', 'Thai Baht'),
  idr('IDR', 'Rp', 'Indonesian Rupiah'),
  hkd('HKD', r'HK$', 'Hong Kong Dollar'),
  nzd('NZD', r'NZ$', 'New Zealand Dollar'),
  php('PHP', '₱', 'Philippine Peso'),
  try_('TRY', '₺', 'Turkish Lira'), // try is a reserved keyword
  aed('AED', 'د.إ', 'UAE Dirham'),
  sar('SAR', '﷼', 'Saudi Riyal'),
  myr('MYR', 'RM', 'Malaysian Ringgit'),
  vnd('VND', '₫', 'Vietnamese Dong'),
  egp('EGP', 'E£', 'Egyptian Pound');

  const Currency(this.code, this.symbol, this.name);

  /// ISO 4217 currency code (e.g., USD, EUR)
  final String code;

  /// Currency symbol (e.g., $, €, £)
  final String symbol;

  /// Full currency name
  final String name;

  /// Get currency by code
  static Currency fromCode(String code) {
    final upperCode = code.toUpperCase();
    return Currency.values.firstWhere(
      (c) => c.code == upperCode,
      orElse: () => Currency.inr,
    );
  }

  /// Get currency by code, returns null if not found
  static Currency? maybeFromCode(String code) {
    final upperCode = code.toUpperCase();
    for (final currency in Currency.values) {
      if (currency.code == upperCode) {
        return currency;
      }
    }
    return null;
  }

  /// Get all currency codes
  static List<String> get allCodes =>
      Currency.values.map((c) => c.code).toList();

  /// Get all major currency codes (most commonly used)
  static List<String> get majorCodes => [
        'INR',
        'USD',
        'EUR',
        'GBP',
        'JPY',
        'CAD',
        'AUD',
        'CHF',
        'CNY',
        'BRL',
        'SGD',
        'HKD',
        'NZD',
      ];

  /// Format amount with currency symbol
  String format(double amount) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  /// Format amount with currency code
  String formatWithCode(double amount) {
    return '$code ${amount.toStringAsFixed(2)}';
  }
}
