import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:fintrack/core/extensions/widget_extensions.dart';
import 'package:fintrack/core/routes/app_routes.dart';
import 'package:fintrack/core/routes/route_enum.dart';
import 'package:fintrack/core/widgets/app_widgets.dart';
import 'package:fintrack/generated/l10n.dart';

class AppRouter {
  const AppRouter._();

  /// The global key used to access navigator without context
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// The name of the route that loads on app startup
  static final String initialRoute = RouteEnum.splashScreen.path;

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: initialRoute,
    observers: [
      NavigationHistoryObserver(),
    ],
    routes: [
      ...AppRoutes().routes,
    ],
    errorPageBuilder: (context, state) {
      return MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text(S.current.appName),
          ),
          body: NoDataWidget(text: S.current.noDataFound).applySafeArea(),
        ),
      );
    },
  );

  static Future<dynamic> pushNamed(String routeName, {dynamic args}) {
    return router.pushNamed(routeName, extra: args);
  }

  static Future<void> pushNamedAndRemoveUntil(String routeName, String untilRoute, {dynamic args}) {
    router.goNamed(untilRoute);
    return pushNamed(routeName, args: args);
  }

  static void startNewRoute(String routeName, {dynamic args}) {
    router.goNamed(routeName, extra: args);
  }

  static Future<dynamic> pushReplacement(String routeName, {dynamic args}) {
    return router.pushReplacementNamed(routeName, extra: args);
  }

  static Future<dynamic> popAndPushNamed(String routeName, {dynamic args}) {
    if (router.canPop()) {
      router.pop();
    }

    return pushNamed(routeName, args: args);
  }

  static Future<void> pop([dynamic result]) async {
    if (router.canPop()) {
      router.pop(result);
    }
  }

  static void popUntil(String routeName) {
    router.goNamed(routeName);
  }

  static void popUntilRoot() {
    while (router.canPop()) {
      router.pop();
    }
  }
}
