enum RouteEnum {
  splashScreen('/splash'),
  onboardingScreen('/onboarding'),
  dashboardScreen('/dashboard'),
  addExpenseScreen('/add-expense')
  ;

  const RouteEnum(this.path);

  final String path;
}
