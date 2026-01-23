import 'package:fintrack/core/database/index.dart';
import 'package:fintrack/core/extensions/context_extensions.dart';
import 'package:flutter/widgets.dart';

class Settings {
  static late HiveStorage storage;

  static void init(BuildContext context) {
    storage = context.readProvider(hiveStorageProvider);
  }

  // Access token
  static String? get accessToken {
    return storage.get<String>(key: HiveKeys.accessToken);
  }

  static set accessToken(String? value) {
    storage.put(key: HiveKeys.accessToken, value: value);
  }

  // Firebase token
  static String get firebaseToken {
    return storage.get<String>(key: HiveKeys.firebaseToken) ?? '';
  }

  static set firebaseToken(String? value) {
    storage.put(key: HiveKeys.firebaseToken, value: value ?? '');
  }
}
