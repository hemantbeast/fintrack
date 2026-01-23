import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class ProviderMonitoringObserver extends ProviderObserver {
  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    super.didAddProvider(context, value);
    _recordLog('provider: ${context.provider} initialized with $value');
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    super.didDisposeProvider(context);
    _recordLog('provider: ${context.provider} was disposed');
  }

  @override
  void didUpdateProvider(ProviderObserverContext context, Object? previousValue, Object? newValue) {
    super.didUpdateProvider(context, previousValue, newValue);
    _recordLog('provider: ${context.provider} updated to $newValue');
  }

  @override
  void providerDidFail(ProviderObserverContext context, Object error, StackTrace stackTrace) {
    super.providerDidFail(context, error, stackTrace);
    _recordLog('provider: ${context.provider} threw $error at $stackTrace');
  }

  void _recordLog(String message) {
    if (!kIsWeb) {
      // FirebaseCrashlytics.instance.log(message);
    }
  }
}
