enum RouteEnum {
  splashScreen('/splash'),
  onboardingScreen('/onboarding'),
  dashboardScreen('/dashboard')
  ;

  const RouteEnum(this.path);

  final String path;
}
