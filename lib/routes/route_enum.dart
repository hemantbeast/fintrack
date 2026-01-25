enum RouteEnum {
  splashScreen('/splash'),
  onboardingScreen('/onboarding'),
  dashboardScreen('/dashboard'),
  addExpenseScreen('/add-expense'),
  allTransactionsScreen('/all-transactions'),
  ;

  const RouteEnum(this.path);

  final String path;
}
