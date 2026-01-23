import 'package:fintrack/core/extensions/string_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NavigatorMonitoringObserver extends NavigatorObserver {
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _recordLog(type: 'Pop', route: previousRoute, previousRoute: route);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _recordLog(type: 'Push', route: route, previousRoute: previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _recordLog(type: 'Replace', route: newRoute, previousRoute: oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _recordLog(type: 'Remove', route: route, previousRoute: previousRoute);
  }

  void _recordLog({required String type, Route<dynamic>? route, Route<dynamic>? previousRoute}) {
    final isRouteEmpty = route?.settings.name.isNullOrEmpty() ?? true;
    final isPreviousRouteEmpty = previousRoute?.settings.name.isNullOrEmpty() ?? true;

    if (isRouteEmpty && isPreviousRouteEmpty) {
      return;
    }

    if (!kIsWeb) {
      // FirebaseCrashlytics.instance.log('navigation: $type from ${previousRoute?.settings.name} to ${route?.settings.name}');
    }
  }
}
