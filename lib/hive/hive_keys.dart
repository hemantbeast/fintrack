class HiveKeys {
  static const String accessToken = 'AccessTokenKey';

  static const String firebaseToken = 'FirebaseTokenKey';

  static const String isOnboardingShown = 'IsOnboardingShown';

  static List<String> get logoutKeys {
    return <String>[
      accessToken,
    ];
  }
}

enum HiveBoxes {
  preferences(boxName: 'preferences'),
  login(boxName: 'login', key: 'LoginKey'),
  balance(boxName: 'balance', key: 'BalanceKey'),
  transactions(boxName: 'transactions', key: 'TransactionsKey'),
  budgets(boxName: 'budgets', key: 'BudgetsKey'),
  exchangeRates(boxName: 'exchange_rates', key: 'ExchangeRatesKey')
  ;

  const HiveBoxes({required this.boxName, this.key = ''});

  final String boxName;

  final String key;

  static List<HiveBoxes> get logoutBoxes {
    final list = HiveBoxes.values.where((e) {
      return e != HiveBoxes.preferences;
    }).toList();

    return list;
  }
}
