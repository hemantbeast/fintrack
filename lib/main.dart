import 'package:fintrack/core/observers/provider_monitoring_observer.dart';
import 'package:fintrack/fintrack_app.dart';
import 'package:fintrack/hive/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode && !kIsWeb) {
      // FirebaseCrashlytics.instance.log('fatal error:\n${details.exceptionAsString()}');
      // FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    }
  };

  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (kReleaseMode && !kIsWeb) {
      // FirebaseCrashlytics.instance.log('error:\n$error\nstack:\n$stack');
      // FirebaseCrashlytics.instance.recordError(error, stack, printDetails: true);
    } else {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stack);
    }
    return true;
  };

  // initialize hive storage
  final hiveStorage = await HiveStorage.getInstance();

  runApp(
    ProviderScope(
      observers: [
        ProviderMonitoringObserver(),
      ],
      overrides: [
        hiveStorageProvider.overrideWithValue(hiveStorage),
      ],
      child: const FintrackApp(),
    ),
  );
}
