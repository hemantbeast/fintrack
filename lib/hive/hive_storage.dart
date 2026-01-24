import 'dart:convert';

import 'package:fintrack/constants/app_constants.dart';
import 'package:fintrack/core/extensions/string_extensions.dart';
import 'package:fintrack/hive/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:path/path.dart' as path_helper;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final hiveStorageProvider = Provider<HiveStorage>((ref) => throw Error());

class HiveStorage {
  HiveStorage._();

  static late HiveStorage _instance;

  static const String _encryptionBoxKey = 'HiveEncryptionKey';
  static const String _hiveVersionKey = 'HiveVersionKey';
  static const String _subDirPath = 'database_boxes';

  static late SharedPreferences _sharedPref;
  static late HiveAesCipher _encryptionCipher;

  final Map<HiveBoxes, Box<dynamic>> _boxes = {};

  static Future<HiveStorage> getInstance({VoidCallback? registerAdapters, VoidCallback? onVersionChanged}) async {
    WidgetsFlutterBinding.ensureInitialized();
    _sharedPref = await SharedPreferences.getInstance();
    _instance = HiveStorage._();

    // Check & update hive version
    await _checkHiveVersion(onVersionChanged);

    _encryptionCipher = await _encryptionKey;

    if (kIsWeb) {
      await Hive.initFlutter();
    } else {
      final appDir = await getApplicationSupportDirectory();
      final path = path_helper.join(appDir.path, _subDirPath);
      Hive.init(path);
    }

    registerAdapters?.call();
    return _instance;
  }

  static Future<void> _checkHiveVersion(VoidCallback? onVersionChanged) async {
    final keyString = _sharedPref.getString(_hiveVersionKey);

    if (keyString.isNullOrEmpty()) {
      await _sharedPref.setString(_hiveVersionKey, AppConstants.hiveVersion);
      return;
    }

    if (!keyString.equalsIgnoreCase(AppConstants.hiveVersion)) {
      await Future.wait([_sharedPref.setString(_hiveVersionKey, AppConstants.hiveVersion), deleteFiles()]);
      onVersionChanged?.call();
    }
  }

  static Future<HiveAesCipher> get _encryptionKey async {
    late Uint8List encryptionKey;
    final keyString = _sharedPref.getString(_encryptionBoxKey);

    if (keyString.isNullOrEmpty()) {
      final key = Hive.generateSecureKey();
      await _sharedPref.setString(_encryptionBoxKey, base64UrlEncode(key));

      encryptionKey = Uint8List.fromList(key);
    } else {
      encryptionKey = base64Url.decode(keyString!);
    }
    return HiveAesCipher(encryptionKey);
  }

  /// Get the box, if it doesn't exist, then open the box.
  Future<Box<T>> getBox<T>(HiveBoxes boxEnum) async {
    if (!_boxes.containsKey(boxEnum)) {
      debugPrint('Box opening: ${boxEnum.boxName}');

      final box = await Hive.openBox<T>(boxEnum.boxName, encryptionCipher: _encryptionCipher);
      _boxes[boxEnum] = box;
    }
    return _boxes[boxEnum]! as Box<T>;
  }

  // Get a box if it's already open
  Box<T>? _getOpenBox<T>(HiveBoxes boxEnum) {
    if (_boxes.containsKey(boxEnum)) {
      return _boxes[boxEnum]! as Box<T>;
    }
    return null;
  }

  /// Default get value for primitive data types
  T? get<T>({required String key, T? defaultValue}) {
    final box = _getOpenBox<dynamic>(HiveBoxes.preferences);
    return box?.get(key, defaultValue: defaultValue) as T?;
  }

  /// Default put value for primitive data types
  Future<void> put<T>({required String key, required T value}) async {
    final box = _getOpenBox<dynamic>(HiveBoxes.preferences);
    return box?.put(key, value);
  }

  /// Get all items from a box
  Future<List<T>> getAllItems<T>(HiveBoxes boxEnum) async {
    final box = await getBox<T>(boxEnum);
    return box.values.toList();
  }

  /// Get item from a box by it's key
  Future<T?> getItemByKey<T>(HiveBoxes boxEnum) async {
    final box = await getBox<T>(boxEnum);
    return box.get(boxEnum.key);
  }

  /// Save a list of items to a box
  Future<void> saveAllItems<T>(HiveBoxes boxEnum, List<T> items, {required String Function(T item) keyExtractor}) async {
    final box = await getBox<T>(boxEnum);
    final entries = <String, T>{};

    for (final item in items) {
      final key = keyExtractor(item);
      entries[key] = item;
    }

    await box.putAll(entries);
  }

  /// Save an item to a box using it's key
  Future<void> saveItem<T>(HiveBoxes boxEnum, T item) async {
    final box = await getBox<T>(boxEnum);
    await box.put(boxEnum.key, item);
  }

  /// Delete all items from box
  Future<void> deleteAllItems(HiveBoxes boxEnum) async {
    if (_boxes.containsKey(boxEnum)) {
      await _boxes[boxEnum]!.clear();
      _boxes.remove(boxEnum);
    }
  }

  /// Delete a item from box using it's key
  Future<void> deleteItem<T>(HiveBoxes boxEnum) async {
    final box = await getBox<T>(boxEnum);
    return box.delete(boxEnum.key);
  }

  /// Close a specific box
  Future<void> closeBox(HiveBoxes boxEnum) async {
    if (_boxes.containsKey(boxEnum)) {
      await _boxes[boxEnum]!.close();
      _boxes.remove(boxEnum);
    }
  }

  /// Close all boxes
  Future<void> closeAllBoxes() async {
    for (final box in _boxes.values) {
      await box.close();
    }
    _boxes.clear();
  }

  /// Delete all box files from disk, except for preferences.
  /// This is useful when the we manually change the hive version.
  static Future<void> deleteFiles() async {
    final boxes = HiveBoxes.values.where((e) => e != HiveBoxes.preferences).toList();

    try {
      final appDir = await getApplicationSupportDirectory();
      final path = path_helper.join(appDir.path, _subDirPath);

      for (final box in boxes) {
        await Hive.deleteBoxFromDisk(box.boxName, path: path);
        _instance._boxes.remove(box);
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }
}
