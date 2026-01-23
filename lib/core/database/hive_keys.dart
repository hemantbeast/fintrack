class HiveKeys {
  static const String accessToken = 'AccessTokenKey';

  static const String firebaseToken = 'FirebaseTokenKey';

  static List<String> get logoutKeys {
    return <String>[
      accessToken,
    ];
  }
}

enum HiveBoxes {
  preferences('preferences'),
  login('login')
  ;

  const HiveBoxes(this.boxName);

  final String boxName;

  static List<HiveBoxes> get logoutBoxes {
    return <HiveBoxes>[
      login, //mcf
    ];
  }
}
