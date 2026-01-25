import 'package:fintrack/core/routes/base_routes.dart';
import 'package:fintrack/features/budget/domain/entities/budget.dart';
import 'package:fintrack/features/budget/ui/add_budget_page.dart';
import 'package:fintrack/features/budget/ui/budget_planning_page.dart';
import 'package:fintrack/features/dashboard/ui/all_transactions_page.dart';
import 'package:fintrack/features/dashboard/ui/dashboard_page.dart';
import 'package:fintrack/features/expenses/ui/add_expense_page.dart';
import 'package:fintrack/features/onboarding/onboarding_page.dart';
import 'package:fintrack/features/splash/ui/splash_page.dart';
import 'package:fintrack/routes/route_enum.dart';
import 'package:go_router/go_router.dart';

class AppRoutes with BaseRoutes {
  List<RouteBase> get routes => [
    /* Splash */
    GoRoute(
      path: RouteEnum.splashScreen.path,
      name: RouteEnum.splashScreen.name,
      pageBuilder: (context, state) {
        return buildMaterialPage(
          key: state.pageKey,
          name: RouteEnum.splashScreen.name,
          child: const SplashPage(),
        );
      },
    ),
    /* Onboarding */
    GoRoute(
      path: RouteEnum.onboardingScreen.path,
      name: RouteEnum.onboardingScreen.name,
      pageBuilder: (context, state) {
        return buildMaterialPage(
          key: state.pageKey,
          name: RouteEnum.onboardingScreen.name,
          child: const OnboardingPage(),
        );
      },
    ),
    /* Dashboard */
    GoRoute(
      path: RouteEnum.dashboardScreen.path,
      name: RouteEnum.dashboardScreen.name,
      pageBuilder: (context, state) {
        return buildMaterialPage(
          key: state.pageKey,
          name: RouteEnum.dashboardScreen.name,
          child: const DashboardPage(),
        );
      },
    ),
    /* Add Expense */
    GoRoute(
      path: RouteEnum.addExpenseScreen.path,
      name: RouteEnum.addExpenseScreen.name,
      pageBuilder: (context, state) {
        return buildMaterialPage(
          key: state.pageKey,
          name: RouteEnum.addExpenseScreen.name,
          child: const AddExpensePage(),
        );
      },
    ),
    /* All Transactions */
    GoRoute(
      path: RouteEnum.allTransactionsScreen.path,
      name: RouteEnum.allTransactionsScreen.name,
      pageBuilder: (context, state) {
        return buildMaterialPage(
          key: state.pageKey,
          name: RouteEnum.allTransactionsScreen.name,
          child: const AllTransactionsPage(),
        );
      },
    ),
    /* Budget Planning */
    GoRoute(
      path: RouteEnum.budgetPlanningScreen.path,
      name: RouteEnum.budgetPlanningScreen.name,
      pageBuilder: (context, state) {
        return buildMaterialPage(
          key: state.pageKey,
          name: RouteEnum.budgetPlanningScreen.name,
          child: const BudgetPlanningPage(),
        );
      },
    ),
    /* Add/Edit Budget */
    GoRoute(
      path: RouteEnum.addBudgetScreen.path,
      name: RouteEnum.addBudgetScreen.name,
      pageBuilder: (context, state) {
        final budget = state.extra as Budget?;
        return buildMaterialPage(
          key: state.pageKey,
          name: RouteEnum.addBudgetScreen.name,
          child: AddBudgetPage(budget: budget),
        );
      },
    ),
  ];
}
