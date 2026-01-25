enum RouteEnum {
  splashScreen('/splash'),
  onboardingScreen('/onboarding'),
  dashboardScreen('/dashboard'),
  addExpenseScreen('/add-expense'),
  allTransactionsScreen('/all-transactions'),
  budgetPlanningScreen('/budget-planning'),
  addBudgetScreen('/add-budget'),
  ;

  const RouteEnum(this.path);

  final String path;
}
