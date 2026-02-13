import 'dart:async';
import 'dart:io';

import 'package:fintrack/hive/hive_registrar.g.dart';
import 'package:fintrack/hive/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

/// Base class for integration tests that handles common setup
abstract class IntegrationTestBase {
  static HiveStorage? _hiveStorage;
  static ProviderContainer? _container;

  /// Initialize integration test binding
  static Future<void> initialize() async {
    // Configure platform channel mock for PackageInfo
    _setupPackageInfoMock();

    // Configure platform channel mock for PathProvider
    await _setupPathProviderMock();
  }

  /// Setup PackageInfo platform channel mock
  static void _setupPackageInfoMock() {
    const channel = MethodChannel('dev.fluttercommunity.plus/package_info');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'getAll') {
            return {
              'appName': 'FinTrack',
              'packageName': 'com.example.fintrack',
              'version': '1.0.0',
              'buildNumber': '1',
            };
          }
          return null;
        });
  }

  /// Setup PathProvider platform channel mock
  static Future<void> _setupPathProviderMock() async {
    final directory = await getTemporaryDirectory();

    const channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'getTemporaryDirectory':
            case 'getApplicationDocumentsDirectory':
            case 'getApplicationSupportDirectory':
              return directory.path;
            default:
              return null;
          }
        });
  }

  /// Initialize Hive storage for testing
  static Future<HiveStorage> initializeHive() async {
    if (_hiveStorage != null) return _hiveStorage!;

    // Get temporary directory for Hive
    final tempDir = await getTemporaryDirectory();
    final hivePath =
        '${tempDir.path}/hive_test_${DateTime.now().millisecondsSinceEpoch}';

    // Create test directory
    final testDir = Directory(hivePath);
    if (!testDir.existsSync()) {
      testDir.createSync(recursive: true);
    }

    // Initialize Hive with test path
    Hive.init(hivePath);
    Hive.registerAdapters();

    _hiveStorage = await HiveStorage.getInstance(
      registerAdapters: () {}, // Already registered above
    );

    return _hiveStorage!;
  }

  /// Get or create ProviderContainer with Hive override
  static ProviderContainer getProviderContainer() {
    if (_container != null) return _container!;

    if (_hiveStorage == null) {
      throw StateError(
        'Hive must be initialized before creating ProviderContainer',
      );
    }

    _container = ProviderContainer(
      overrides: [
        hiveStorageProvider.overrideWithValue(_hiveStorage!),
      ],
    );

    return _container!;
  }

  /// Clean up all test resources
  static Future<void> cleanup() async {
    _container?.dispose();
    _container = null;

    if (_hiveStorage != null) {
      await _hiveStorage!.closeAllBoxes();
      _hiveStorage = null;
    }

    // Clean up Hive directory
    try {
      final tempDir = await getTemporaryDirectory();
      final hiveDirs = tempDir.listSync().where(
        (entity) => entity is Directory && entity.path.contains('hive_test_'),
      );
      for (final dir in hiveDirs) {
        await dir.delete(recursive: true);
      }
    } catch (e) {
      debugPrint('Error cleaning up Hive directories: $e');
    }
  }

  /// Clear all Hive boxes for clean test state
  static Future<void> clearHiveBoxes() async {
    if (_hiveStorage == null) return;

    // Clear each box individually
    for (final boxEnum in HiveBoxes.values) {
      await _hiveStorage!.deleteAllItems(boxEnum);
    }
  }

  /// Wait for UI to settle (useful after async operations)
  static Future<void> pumpAndSettle(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
  }
}
