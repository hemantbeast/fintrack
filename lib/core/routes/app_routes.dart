import 'package:fintrack/core/routes/base_routes.dart';
import 'package:fintrack/core/routes/route_enum.dart';
import 'package:fintrack/features/dashboard/ui/dashboard_page.dart';
import 'package:fintrack/features/splash/ui/splash_page.dart';
import 'package:go_router/go_router.dart';

class AppRoutes with BaseRoutes {
  List<RouteBase> get routes => [
    /* Splash */
    GoRoute(
      path: RouteEnum.splashScreen.path,
      name: RouteEnum.splashScreen.name,
      pageBuilder: (context, state) {
        return buildMaterialPage(key: state.pageKey, name: RouteEnum.splashScreen.name, child: const SplashPage());
      },
    ),
    /* Onboarding */
    GoRoute(
      path: RouteEnum.dashboardScreen.path,
      name: RouteEnum.dashboardScreen.name,
      pageBuilder: (context, state) {
        return buildMaterialPage(key: state.pageKey, name: RouteEnum.dashboardScreen.name, child: const DashboardPage());
      },
    ),
  ];
}
